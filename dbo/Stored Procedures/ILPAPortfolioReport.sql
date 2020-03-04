CREATE PROCEDURE [dbo].[ILPAPortfolioReport] @fundID      INT, 
                                             @portfolioID INT, 
                                             @date        DATETIME
AS
     DECLARE @holding TABLE
     (companyid         INT, 
      portfolioid       INT, 
      holdingCompanyID1 INT, 
      holdingCompanyID2 INT, 
      ModuleID1         INT, 
      ModuleID2         INT, 
      IsHolding1        BIT, 
      IsHolding2        BIT
     );
     INSERT INTO @holding
            SELECT t.TargetPortfolioID, 
                   p.portfolioid, 
                   s1.ObjectID, 
                   s2.ObjectID, 
                   s1.ModuleID, 
                   s2.ModuleID, 
                   (CASE
                        WHEN EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_PortfolioVehicle pv
                     JOIN tbl_portfolio h1 ON h1.PortfolioID = pv.portfolioid
                WHERE h1.TargetPortfolioID = s1.ObjectID
                      AND s1.ModuleID = 5
                      AND pv.VehicleID = @fundID
            )
                        THEN 1
                        ELSE 0
                    END), 
                   (CASE
                        WHEN EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_PortfolioVehicle pv
                     JOIN tbl_portfolio h2 ON h2.PortfolioID = pv.portfolioid
                WHERE h2.TargetPortfolioID = s2.ObjectID
                      AND s2.ModuleID = 5
                      AND pv.VehicleID = @fundID
            )
                        THEN 1
                        ELSE 0
                    END)
            FROM tbl_portfolio t
                 JOIN tbl_ShareholdersOwned s1 ON s1.TargetPortfolioID = t.TargetPortfolioID
                                                  AND s1.ModuleID = 5
                 JOIN tbl_Portfolio p ON p.TargetPortfolioID = s1.ObjectID
                 LEFT JOIN tbl_ShareholdersOwned s2 ON s2.TargetPortfolioID = s1.ObjectID
            --AND s2.ModuleID = 5
            WHERE t.PortfolioID = @portfolioID;
     UPDATE h
       SET 
           ModuleID2 = 3, 
           Isholding2 = 1, 
           holdingCompanyID2 = @fundID
     FROM @holding h
     WHERE ModuleID2 IS NULL
           AND NOT EXISTS
     (
         SELECT TOP 1 1
         FROM tbl_ShareholdersOwned s
         WHERE s.objectid = h.companyID
               AND s.moduleid = 5
     );
     UPDATE h
       SET 
           ModuleID1 = 3, 
           IsHolding1 = 1, 
           holdingCompanyID1 = @fundID
     FROM @holding h
     WHERE ModuleID1 IS NULL;
     SELECT t.*, 
            pe.EnterpriseValue, 
            pe.NetFinancialDebt, 
            pe.EquityValue
     FROM
     (
         SELECT pv.PortfolioID, 
                pv.VehicleID, 
                v.Name FundName, 
                CompanyName, 
                (CASE
                     WHEN EXISTS
         (
             SELECT TOP 1 1
             FROM @holding h
             WHERE h.companyid = p.TargetPortfolioID
         )
                     THEN
         (
             SELECT TOP 1 ISNULL(date, 0)
             FROM tbl_PortfolioShareholdingOperations pso
                  JOIN @holding h ON h.portfolioid = pso.PortfolioID
             WHERE h.companyid = p.TargetPortfolioID
                   AND 1 = CASE
                               WHEN ToTypeID = h.ModuleID2
                                    AND ToID = h.holdingCompanyID2
                                    AND (h.IsHolding2 = 1
                                         OR h.ModuleID2 = 3)
                               THEN 1
                           END
                   AND ISNULL(isConditional, 0) = 0
                   AND pso.Date <= GETDATE()
             ORDER BY date
         )
                     ELSE
         (
             SELECT TOP 1 ISNULL(date, 0)
             FROM tbl_PortfolioShareholdingOperations pso
             WHERE pso.PortfolioID = p.TargetPortfolioID
                   AND ToTypeID = 3
                   AND ToID = @FundID
                   AND ISNULL(isConditional, 0) = 0
                   AND pso.Date <= GETDATE()
             ORDER BY date
         )
                 END) ClosingDate, 
         (
             SELECT CompanyIndustryTitle
             FROM tbl_companyindustries cind
             WHERE cind.CompanyIndustryID = cc.CompanyIndustryID
         ) Industry, 
                Region Geography, 
         (
             SELECT CurrencyCode
             FROM tbl_currency c
             WHERE c.currencyid = pl.currencyid
         ) Currency, 
                (ISNULL(
         (
             SELECT TOP 1 Owned
             FROM tbl_ShareholdersOwned s
                  JOIN @holding h ON s.TargetPortfolioID = h.companyid
                                     AND s.ObjectID = h.holdingCompanyID1
                                     AND s.ModuleID = h.ModuleID1
                                     AND h.companyid = p.TargetPortfolioID
         ), 1) * ISNULL(
         (
             SELECT TOP 1 Owned
             FROM tbl_ShareholdersOwned s
                  JOIN @holding h ON s.TargetPortfolioID = h.holdingCompanyID1
                                     AND s.ObjectID = h.holdingCompanyID2
                                     AND s.ModuleID = h.ModuleID2
             WHERE h.companyid = p.TargetPortfolioID
                   AND (h.IsHolding2 = 1
                        OR h.ModuleID2 = 3)
         ), 1)) / 100 Ownership, 
                CAST(CASE
                         WHEN EXISTS
         (
             SELECT TOP 1 1
             FROM @holding h
             WHERE h.companyid = p.TargetPortfolioID
         )
                         THEN
         (
             SELECT ISNULL(SUM(Amount), 0)
             FROM tbl_PortfolioShareholdingOperations pso
                  JOIN @holding h ON h.portfolioid = pso.PortfolioID
             WHERE h.companyid = p.TargetPortfolioID
                   AND 1 = CASE
                               WHEN ToTypeID = h.ModuleID2
                                    AND ToID = h.holdingCompanyID2
                               THEN 1
                           END
                   AND ISNULL(isConditional, 0) = 0
                   AND pso.Date <= GETDATE()
         )
                         ELSE
         (
             SELECT ISNULL(SUM(Amount), 0)
             FROM tbl_PortfolioShareholdingOperations pso
             WHERE pso.PortfolioID = p.portfolioid
                   AND ToTypeID = 3
                   AND ToID = @FundID
                   AND ISNULL(isConditional, 0) = 0
                   AND pso.Date <= GETDATE()
         )
                     END AS DECIMAL(18, 2)) + CAST(ISNULL(
         (
             SELECT TOP 1 CASE
                              WHEN
             (
                 SELECT FromTypeID
                 FROM tbl_PortfolioShareholdingOperations s
                 WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
             ) = 3
                              THEN ISNULL(SUM(pfp.AmountDue * -1), 0)
                              ELSE ISNULL(SUM(pfp.AmountDue), 0)
                          END
             FROM tbl_PortfolioFollowOnPayment pfp
                  INNER JOIN tbl_PortfolioShareholdingOperations pso ON pso.ShareholdingOperationID = pfp.ShareholdingOperationID
             WHERE pso.PortfolioID = p.portfolioid
                   AND ISNULL(isConditional, 0) = 0
                   AND ToTypeID = 3
                   AND ToID = @FundID
                   AND pso.Date <= GETDATE()
             GROUP BY pfp.ShareholdingOperationID
         ), 0) AS DECIMAL(18, 2)) + CAST(
         (
             SELECT ISNULL(SUM(Amount), 0)
             FROM tbl_PortfolioGeneralOperation g
                  JOIN @holding h ON h.portfolioid = g.PortfolioID
             WHERE h.companyid = p.TargetPortfolioID
                   AND ISNULL(g.isConditional, 0) = 0
                   AND (h.IsHolding2 = 1
                        OR h.ModuleID2 = 3)
                   AND g.Date <= GETDATE()
         ) AS DECIMAL(18, 2)) 'InvestedAmount', 
                ((
         (
             SELECT ISNULL(SUM(pso.amount), 0)
             FROM tbl_PortfolioShareholdingOperations pso
                  JOIN @holding h ON h.portfolioid = pso.PortfolioID
             WHERE h.companyid = p.TargetPortfolioID
                   AND 1 = CASE
                               WHEN FromTypeID = h.ModuleID2
                                    AND FromID = h.holdingCompanyID2
                               THEN 1
                           END
                   AND ISNULL(isConditional, 0) = 0
                   AND pso.Date <= GETDATE()
         ) +
         (
             SELECT ISNULL(SUM((CASE
                                    WHEN typeid IN(4, 5, 2)
                                    THEN Amount
                                    WHEN typeid IN(12, 9)
                                    THEN-1 * amount
                                END)), 0)
             FROM tbl_PortfolioGeneralOperation g
                  JOIN @holding h ON h.portfolioid = g.PortfolioID
             WHERE h.companyid = p.TargetPortfolioID
                   AND g.Date <= GETDATE()
         ))) 'Proceeds', 
         (
             SELECT TOP 1 FinalValuation
             FROM tbl_PortfolioValuation pso
                  JOIN @holding h ON h.portfolioid = pso.PortfolioID
             WHERE h.companyid = p.TargetPortfolioID
                   AND pso.VehicleID = @FundID
                   AND pso.Date <= @date
             ORDER BY Date DESC
         ) NAV, 
         (
             SELECT TOP 1 Notes
             FROM tbl_PortfolioValuation vn
             WHERE vn.vehicleid = pv.vehicleid
                   AND vn.portfolioid = p.portfolioid
                   AND vn.date <= @date
             ORDER BY vn.date DESC
         ) 'Valuation Methodology', 
                cc.CompanyComments Notes, 
                InvestmentRiskAssessment TransactionBackground, 
                InvestmentBackgroundNotes InvestmentThesis, 
         (
             SELECT TOP 1 Comments
             FROM tbl_companybusinessupdates cbu
             WHERE cbu.companyid = cc.companycontactid
                   AND cbu.date <= @date
             ORDER BY cbu.date DESC
         ) RecentDevelopments, 
                GovernanceRisks 'KeyIdentifiedRisks', 
                MeasureTaken 'Sponsor'
         FROM tbl_portfoliovehicle pv
              JOIN tbl_vehicle v ON pv.vehicleid = v.vehicleid
              JOIN tbl_portfolio p ON p.portfolioid = pv.portfolioid
              JOIN tbl_companycontact cc ON cc.companycontactid = p.targetportfolioid
              LEFT JOIN tbl_portfoliooptional po ON po.portfolioid = p.portfolioid
              LEFT JOIN tbl_portfoliolegal pl ON po.portfolioid = pl.portfolioid
         WHERE v.vehicleID = @fundID
               AND p.portfolioid = @portfolioID
     ) t
     OUTER APPLY
     (
         SELECT *
         FROM tbl_PortfolioEnterprise pe
         WHERE pe.portfolioid = t.portfolioid
               AND pe.date = t.ClosingDate
     ) pe;
