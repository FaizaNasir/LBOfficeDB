CREATE PROC [dbo].[proc_PortfolioStill2]
(@FundID   INT, 
 @userrole VARCHAR(100), 
 @date     DATETIME     = NULL
)
AS
    BEGIN
        IF @date IS NULL
            SET @date = GETDATE();
        DECLARE @temp1 TABLE
        (companyid   INT, 
         companyname VARCHAR(100), 
         portfolioid INT
        );
        DECLARE @temp2 TABLE
        (companyid   INT, 
         companyname VARCHAR(100), 
         portfolioid INT
        );
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
        INSERT INTO @temp1
               SELECT DISTINCT 
                      p.TargetPortfolioID, 
                      c.CompanyName, 
                      p.PortfolioID
               FROM tbl_PortfolioVehicle pv
                    JOIN tbl_Portfolio p ON pv.PortfolioID = p.PortfolioID
                    JOIN tbl_companycontact c ON c.CompanyContactID = p.TargetPortfolioID
               WHERE VehicleID = @FundID
                     AND STATUS IN(1, 2, 3)
                    AND NOT EXISTS
               (
                   SELECT TOP 1 1
                   FROM tbl_BlockedPermission b
                   WHERE b.moduleName = 'Portfolio'
                         AND UserRole = @userrole
                         AND b.ObjectID = p.PortfolioID
               );
        INSERT INTO @holding
               SELECT t.companyid, 
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
               FROM
               (
                   SELECT *
                   FROM @temp1
                   UNION ALL
                   SELECT *
                   FROM @temp2
               ) t
               JOIN tbl_ShareholdersOwned s1 ON s1.TargetPortfolioID = t.companyid
                                                AND s1.ModuleID = 5
                                                AND ShareholderOwnedDateId =
               (
                   SELECT TOP 1 ShareholderDateId
                   FROM tbl_ShareholdersOwnedDate
                   WHERE TargetPortfolioId = t.companyid
                   --and Date<=@date
                   ORDER BY date DESC
               )
               JOIN tbl_Portfolio p ON p.TargetPortfolioID = s1.ObjectID
               LEFT JOIN tbl_ShareholdersOwned s2 ON s2.TargetPortfolioID = s1.ObjectID
                                                     AND s2.ShareholderOwnedDateId =
               (
                   SELECT TOP 1 ShareholderDateId
                   FROM tbl_ShareholdersOwnedDate
                   WHERE TargetPortfolioId = s1.ObjectID
                   --and Date<=@date
                   ORDER BY date DESC
               );
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
                  AND ShareholderOwnedDateId =
            (
                SELECT TOP 1 ShareholderDateId
                FROM tbl_ShareholdersOwnedDate
                WHERE TargetPortfolioId = h.companyid
                --and Date<=@date
                ORDER BY date DESC
            )
        );
        UPDATE h
          SET 
              ModuleID1 = 3, 
              IsHolding1 = 1, 
              holdingCompanyID1 = @fundID
        FROM @holding h
        WHERE ModuleID1 IS NULL;
        DECLARE @result TABLE
        (PortfolioID       INT, 
         CompanyContactID  INT, 
         ComapanyName      VARCHAR(100), 
         Sector            VARCHAR(100), 
         InvestmentDate    DATETIME, 
         InvestmentValue   DECIMAL(18, 6), 
         Owned             DECIMAL(18, 6), 
         AmountInvested    DECIMAL(18, 6), 
         PortfolioWeight   DECIMAL(18, 6), 
         CompanyComments   VARCHAR(1000), 
         Divestments       DECIMAL(18, 6), 
         PotentialProceeds DECIMAL(18, 6)
        );
        DECLARE @result1 TABLE
        (PortfolioID       INT, 
         CompanyContactID  INT, 
         ComapanyName      VARCHAR(100), 
         Sector            VARCHAR(100), 
         InvestmentDate    DATETIME, 
         InvestmentValue   DECIMAL(18, 6), 
         Owned             DECIMAL(18, 6), 
         AmountInvested    DECIMAL(18, 6), 
         PortfolioWeight   DECIMAL(18, 6), 
         CompanyComments   VARCHAR(1000), 
         Divestments       DECIMAL(18, 6), 
         PotentialProceeds DECIMAL(18, 6)
        );
        INSERT INTO @result
               SELECT DISTINCT 
                      *
               FROM
               (
                   SELECT *
                   FROM
                   (
                       SELECT DISTINCT 
                              t1.PortfolioID, 
                              t1.companyid AS 'CompanyContactID', 
                              t1.companyname 'ComapanyName', 
                              b.BusinessAreaTitle 'Sector', 
                              (CASE
                                   WHEN EXISTS
                       (
                           SELECT TOP 1 1
                           FROM @holding h
                           WHERE h.companyid = t1.companyid
                       )
                                   THEN
                       (
                           SELECT TOP 1 ISNULL(date, 0)
                           FROM tbl_PortfolioShareholdingOperations pso
                                JOIN @holding h ON h.portfolioid = pso.PortfolioID
                           WHERE h.companyid = t1.companyid
                                 AND 1 = CASE
                                             WHEN ToTypeID = h.ModuleID2
                                                  AND ToID = h.holdingCompanyID2
                                             THEN 1
                                         END
                                 AND ISNULL(isConditional, 0) = 0
                                 AND pso.Date <= @date
                           ORDER BY date
                       )
                                   ELSE
                       (
                           SELECT TOP 1 ISNULL(date, 0)
                           FROM tbl_PortfolioShareholdingOperations pso
                           WHERE pso.PortfolioID = t1.portfolioid
                                 AND ToTypeID = 3
                                 AND ToID = @FundID
                                 AND ISNULL(isConditional, 0) = 0
                                 AND pso.Date <= @date
                           ORDER BY date
                       )
                               END) 'InvestmentDate', 
                              dbo.[F_GetDatedNAV_V1](@FundID, t1.portfolioid, t1.companyid, @date, 0) 'InvestmentValue', 
                              (ISNULL(
                       (
                           SELECT TOP 1 Owned
                           FROM tbl_ShareholdersOwned s
                                JOIN @holding h ON s.TargetPortfolioID = h.companyid
                                                   AND s.ObjectID = h.holdingCompanyID1
                                                   AND s.ModuleID = h.ModuleID1
                                                   AND h.companyid = t1.companyid
                                                   AND ShareholderOwnedDateId =
                           (
                               SELECT TOP 1 ShareholderDateId
                               FROM tbl_ShareholdersOwnedDate
                               WHERE TargetPortfolioId = h.companyid
                               --AND Date <= @date
                               ORDER BY date DESC
                           )
                       ), 1) * ISNULL(
                       (
                           SELECT TOP 1 Owned
                           FROM tbl_ShareholdersOwned s
                                JOIN @holding h ON s.TargetPortfolioID = h.holdingCompanyID1
                                                   AND s.ObjectID = h.holdingCompanyID2
                                                   AND s.ModuleID = h.ModuleID2
                           WHERE h.companyid = t1.companyid
                                 AND (h.IsHolding2 = 1
                                      OR h.ModuleID2 = 3)
                                 AND ShareholderOwnedDateId =
                           (
                               SELECT TOP 1 ShareholderDateId
                               FROM tbl_ShareholdersOwnedDate
                               WHERE TargetPortfolioId = h.holdingCompanyID1
                               --AND Date <= @date
                               ORDER BY date DESC
                           )
                       ), 1)) / 100 'Owned', 
                              CAST(CASE
                                       WHEN EXISTS
                       (
                           SELECT TOP 1 1
                           FROM @holding h
                           WHERE h.companyid = t1.companyid
                       )
                                       THEN
                       (
                           SELECT ISNULL(SUM(Amount), 0)
                           FROM tbl_PortfolioShareholdingOperations pso
                                JOIN @holding h ON h.portfolioid = pso.PortfolioID
                           WHERE h.companyid = t1.companyid
                                 AND 1 = CASE
                                             WHEN ToTypeID = h.ModuleID2
                                                  AND ToID = h.holdingCompanyID2
                                             THEN 1
                                         END
                                 AND ISNULL(isConditional, 0) = 0
                                 AND pso.Date <= @date
                       )
                                       ELSE
                       (
                           SELECT ISNULL(SUM(Amount), 0)
                           FROM tbl_PortfolioShareholdingOperations pso
                           WHERE pso.PortfolioID = t1.portfolioid
                                 AND ToTypeID = 3
                                 AND ToID = @FundID
                                 AND ISNULL(isConditional, 0) = 0
                                 AND pso.Date <= @date
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
                           WHERE pso.PortfolioID = t1.portfolioid
                                 AND ISNULL(isConditional, 0) = 0
                                 AND ToTypeID = 3
                                 AND ToID = @FundID
                                 AND pso.Date <= @date
                           GROUP BY pfp.ShareholdingOperationID
                       ), 0) AS DECIMAL(18, 2)) + CAST(
                       (
                           SELECT ISNULL(SUM(Amount), 0)
                           FROM tbl_PortfolioGeneralOperation g
                                JOIN @holding h ON h.portfolioid = g.PortfolioID
                           WHERE h.companyid = t1.companyid
                                 AND ISNULL(g.isConditional, 0) = 0
                                 AND (h.isholding2 = 1
                                      OR h.ModuleID2 = 3)
                                 AND g.Date <= @date
                       ) AS DECIMAL(18, 2)) - CAST(CASE
                                                       WHEN EXISTS
                       (
                           SELECT TOP 1 1
                           FROM @holding h
                           WHERE h.companyid = t1.companyid
                       )
                                                       THEN
                       (
                           SELECT ISNULL(SUM(Amount), 0)
                           FROM tbl_PortfolioShareholdingOperations pso
                                JOIN @holding h ON h.portfolioid = pso.PortfolioID
                           WHERE h.companyid = t1.companyid
                                 AND 1 = CASE
                                             WHEN FromTypeID = 5
                                                  AND FromID = h.holdingCompanyID2
                                                  AND ToID = -2
                                             THEN 1
                                         END
                                 AND ISNULL(isConditional, 0) = 0
                                 AND pso.Date <= @date
                       )
                                                   END AS DECIMAL(18, 2)) 'AmountInvested', 
                              CAST(
                       (
                           SELECT SUM(Amount)
                           FROM tbl_PortfolioShareholdingOperations
                           WHERE ToTypeID = 3
                                 AND ToID = @FundID
                                 AND PortfolioID = t1.PortfolioID
                                 AND Date <= @date
                                 AND ISNULL(isConditional, 0) = 0
                       ) * 100.0 /
                       (
                           SELECT SUM(cc.Amount)
                           FROM tbl_PortfolioVehicle cc
                           WHERE cc.VehicleID = @FundID
                       ) AS DECIMAL(18, 2)) 'PortfolioWeight', 
                              c.CompanyBusinessDesc 'CompanyComments', 
                              ISNULL(
                       (
                           SELECT SUM(Amount)
                           FROM tbl_PortfolioShareholdingOperations
                           WHERE FromTypeID = 3
                                 AND FromID = @FundID
                                 AND PortfolioID = t1.PortfolioID
                                 AND ISNULL(isConditional, 0) = 0
                                 AND date <= @date
                       ), 0) AS 'Divestments', 
                              (((
                       (
                           SELECT ISNULL(SUM(pso.amount), 0)
                           FROM tbl_PortfolioShareholdingOperations pso
                                JOIN @holding h ON h.portfolioid = pso.PortfolioID
                           WHERE h.companyid = t1.companyid
                                 AND 1 = CASE
                                             WHEN FromTypeID = h.ModuleID2
                                                  AND FromID = h.holdingCompanyID2
                                                  AND (h.isholding2 = 1
                                                       OR h.ModuleID2 = 3)
                                             THEN 1
                                         END
                                 AND ISNULL(isConditional, 0) = 0
                                 AND pso.Date <= @date
                       ) +
                       (
                           SELECT ISNULL(SUM(Amount), 0)
                           FROM tbl_PortfolioGeneralOperation g
                                JOIN @holding h ON h.portfolioid = g.PortfolioID
                           WHERE h.companyid = t1.companyid
                                 AND g.Date <= @date
                                 AND TypeID IN(2)
                       )) -
                       (
                           SELECT ISNULL(SUM(Amount), 0)
                           FROM tbl_PortfolioGeneralOperation g
                                JOIN @holding h ON h.portfolioid = g.PortfolioID
                           WHERE h.companyid = t1.companyid
                                 AND g.Date <= @date
                                 AND ISNULL(g.isConditional, 0) = 0
                                 AND TypeID = 6
                       )) +
                       (
                           SELECT ISNULL(SUM(pfp.AmountDue), 0)
                           FROM tbl_PortfolioFollowOnPayment pfp
                                INNER JOIN tbl_PortfolioShareholdingOperations pso ON pso.ShareholdingOperationID = pfp.ShareholdingOperationID
                           WHERE pso.FromTypeID = 3
                                 AND fromID = @FundID
                                 AND pso.PortfolioID = t1.portfolioid
                                 AND pfp.Date <= @date
                                 AND ISNULL(isConditional, 0) = 0
                       )) +
                       (
                           SELECT ISNULL(SUM(Amount), 0)
                           FROM tbl_PortfolioGeneralOperation g
                                JOIN @holding h ON h.portfolioid = g.PortfolioID
                           WHERE h.companyid = t1.companyid
                                 AND ISNULL(g.isConditional, 0) = 0
                                 AND Date <= @date
                                 AND TypeID = 9
                       ) AS 'PotentialProceeds'
                       FROM @temp1 t1
                            JOIN tbl_ShareholdersOwned S ON t1.companyid = s.TargetPortfolioID
                                                            AND s.ModuleID IN(5)
                            JOIN tbl_companycontact c ON c.CompanyContactID = t1.companyid
                            LEFT JOIN tbl_businessarea b ON c.CompanyBusinessAreaID = b.BusinessAreaID
                       WHERE NOT EXISTS
                       (
                           SELECT TOP 1 TargetPortfolioID
                           FROM tbl_ShareholdersOwned oo
                           WHERE oo.ObjectID = t1.companyid
                                 AND ShareholderOwnedDateId =
                           (
                               SELECT TOP 1 ShareholderDateId
                               FROM tbl_ShareholdersOwnedDate
                               WHERE TargetPortfolioId = t1.companyid
                               --AND Date <=@date
                               ORDER BY date DESC
                           )
                       )
                   ) tt
                   WHERE NOT EXISTS
                   (
                       SELECT TOP 1 TargetPortfolioID
                       FROM tbl_ShareholdersOwned oo
                       WHERE oo.ObjectID = tt.CompanyContactID
                   )
               ) tt
               ORDER BY tt.InvestmentDate;
        INSERT INTO @result1
        EXEC [dbo].proc_PortfolioStill3 
             @FundID, 
             @userrole = 'LbofficeAdmin';
        INSERT INTO @result
               SELECT PortfolioID, 
                      CompanyContactID, 
                      ComapanyName, 
                      Sector, 
                      InvestmentDate, 
                      InvestmentValue, 
                      Owned, 
                      AmountInvested, 
                      PortfolioWeight, 
                      CompanyComments, 
                      Divestments, 
                      PotentialProceeds
               FROM @result1 r
               WHERE portfolioid NOT IN
               (
                   SELECT portfolioid
                   FROM @result
               )
                     AND portfolioid NOT IN
               (
                   SELECT r.PortfolioID
                   FROM tbl_ShareholdersOwned s
                        JOIN tbl_portfolio p ON p.targetportfolioid = s.targetportfolioid
                        JOIN tbl_PortfolioVehicle pv ON pv.PortfolioID = p.PortfolioID
                   WHERE pv.VehicleID = @FundID
                         AND s.ObjectID = r.CompanyContactID
                         AND s.ModuleID = 5
               );
        SELECT 1 RowNum, 
               *
        FROM @result;
    END;
