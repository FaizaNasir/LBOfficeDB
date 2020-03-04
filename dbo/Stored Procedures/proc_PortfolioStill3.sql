CREATE PROC [dbo].[proc_PortfolioStill3]
(@FundID   INT, 
 @userrole VARCHAR(100)
)
AS
    BEGIN
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
        INSERT INTO @temp2
               SELECT DISTINCT 
                      s.ObjectID, 
                      c.CompanyName, 
                      p.PortfolioID
               FROM tbl_Shareholders S
                    INNER JOIN tbl_Portfolio p ON p.TargetPortfolioID = s.ObjectID
                    INNER JOIN tbl_PortfolioVehicle pv ON pv.PortfolioID = p.PortfolioID
                    INNER JOIN tbl_companycontact c ON c.CompanyContactID = s.ObjectID
               WHERE s.ModuleID = 5
                     AND VehicleID = @FundID
                     AND STATUS IN(1, 2, 3)
                    AND NOT EXISTS
               (
                   SELECT TOP 1 1
                   FROM tbl_BlockedPermission b
                   WHERE b.moduleName = 'Portfolio'
                         AND UserRole = @userrole
                         AND b.ObjectID = p.PortfolioID
               );
        SELECT DISTINCT 
               t1.PortfolioID, 
               t1.companyid AS 'CompanyContactID', 
               t1.companyname 'ComapanyName', 
               b.BusinessAreaTitle 'Sector', 
        (
            SELECT TOP 1 pso.Date
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.ToID = @FundID
                  AND pso.PortfolioID = t1.PortfolioID
                  AND pso.ToTypeID = 3
            ORDER BY Date
        ) 'InvestmentDate', 
        (
            SELECT TOP 1 FinalValuation
            FROM tbl_PortfolioValuation pso
            WHERE pso.PortfolioID = t1.PortfolioID
                  AND pso.VehicleID = @FundID
            ORDER BY Date DESC
        ) 'InvestmentValue', 
               dbo.[F_NonDiluted](@FundID, 3, GETDATE(), t1.PortfolioID) 'Owned', 
               CAST(
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @FundID
                  AND PortfolioID = t1.PortfolioID
                  AND ISNULL(isConditional, 0) = 0
                  AND tbl_PortfolioShareholdingOperations.Date <= GETDATE()
        ) AS DECIMAL(18, 2)) + CAST(ISNULL(
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
                  AND pso.Date <= GETDATE()
            GROUP BY pfp.ShareholdingOperationID
        ), 0) AS DECIMAL(18, 2)) + CAST(
        (
            SELECT ISNULL(SUM(CASE
                                  WHEN TypeID IN(1, 3, 7, 8)
                                  THEN Amount
                              END), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = t1.PortfolioID
                  AND ISNULL(g.isConditional, 0) = 0
                  AND 1 = CASE
                              WHEN g.fromID = @FundID
                                   AND g.FromModuleID = 3
                              THEN 1
                              WHEN g.toID = @FundID
                                   AND g.toModuleID = 3
                              THEN 1
                          END
                  AND g.Date <= GETDATE()
        ) AS DECIMAL(18, 2)) 'AmountInvested', 
               CAST(
        (
            SELECT SUM(Amount)
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @FundID
                  AND PortfolioID = t1.PortfolioID
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
        ), 0) AS 'Divestments', 
        (
            SELECT ISNULL(SUM(pso.amount), 0)
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.fromid = @FundID
                  AND pso.FromTypeID = 3
                  AND pso.portfolioid = t1.PortfolioID
                  AND ISNULL(isConditional, 0) = 0
        ) +
        (
            SELECT ISNULL(SUM(CASE
                                  WHEN TypeID IN(4, 5, 2)
                                  THEN Amount
                                  WHEN TypeID IN(12, 9)
                                  THEN-1 * Amount
                              END), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = t1.PortfolioID
                  AND ISNULL(g.isConditional, 0) = 0
                  AND 1 = CASE
                              WHEN g.FromModuleID = 3
                                   AND g.FromID = @FundID
                              THEN 1
                              WHEN g.ToModuleID = 3
                                   AND g.ToID = @FundID
                              THEN 1
                          END
        ) AS 'PotentialProceeds'
        FROM @temp1 t1
             JOIN tbl_Shareholders S ON t1.companyid = s.TargetPortfolioID
                                        AND s.ModuleID = 5
             JOIN tbl_companycontact c ON c.CompanyContactID = t1.companyid
             LEFT JOIN tbl_businessarea b ON c.CompanyBusinessAreaID = b.BusinessAreaID
        WHERE s.ObjectID NOT IN
        (
            SELECT companyid
            FROM @temp2
        )
        UNION ALL
        SELECT t.PortfolioID, 
               t.companyid AS 'CompanyContactID', 
               t.companyname 'ComapanyName', 
               b.BusinessAreaTitle 'Sector', 
        (
            SELECT TOP 1 pso.Date
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.ToID = @FundID
                  AND pso.PortfolioID = t.PortfolioID
                  AND pso.ToTypeID = 3
            ORDER BY Date
        ) 'InvestmentDate', 
        (
            SELECT TOP 1 CASE
                             WHEN pso.Discount <> 0
                             THEN pso.FinalValuation
                             ELSE InvestmentValue
                         END
            FROM tbl_PortfolioValuation pso
            WHERE pso.PortfolioID = t.PortfolioID
                  AND pso.VehicleID = @FundID
            ORDER BY Date DESC
        ) 'InvestmentValue', 
               dbo.[F_NonDiluted](@FundID, 3, GETDATE(), t.PortfolioID) 'Owned', 
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @FundID
                  AND PortfolioID = t.PortfolioID
                  AND ISNULL(isConditional, 0) = 0
        ) + ISNULL(
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
            WHERE pso.PortfolioID = t.portfolioid
                  AND ISNULL(isConditional, 0) = 0
            GROUP BY pfp.ShareholdingOperationID
        ), 0) + CAST(
        (
            SELECT ISNULL(SUM(CASE
                                  WHEN TypeID IN(1, 3, 7, 8)
                                  THEN Amount
                              END), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = t.PortfolioID
                  AND ISNULL(g.isConditional, 0) = 0
                  AND 1 = CASE
                              WHEN g.fromID = @FundID
                                   AND g.FromModuleID = 3
                              THEN 1
                              WHEN g.toID = @FundID
                                   AND g.toModuleID = 3
                              THEN 1
                          END
                  AND g.Date <= GETDATE()
        ) AS DECIMAL(18, 2)) AS 'AmountInvested', 
               CAST(
        (
            SELECT SUM(Amount)
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @FundID
                  AND PortfolioID = t.PortfolioID
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
                  AND PortfolioID = t.PortfolioID
                  AND ISNULL(isConditional, 0) = 0
        ), 0) AS 'Divestments', 
        (
            SELECT ISNULL(SUM(pso.amount), 0)
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.fromid = @FundID
                  AND pso.FromTypeID = 3
                  AND pso.portfolioid = t.PortfolioID
                  AND ISNULL(isConditional, 0) = 0
        ) +
        (
            SELECT ISNULL(SUM(CASE
                                  WHEN TypeID IN(4, 5, 2)
                                  THEN Amount
                                  WHEN TypeID IN(12, 9)
                                  THEN-1 * Amount
                              END), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = t.PortfolioID
                  AND ISNULL(g.isConditional, 0) = 0
                  AND 1 = CASE
                              WHEN g.FromModuleID = 3
                                   AND g.FromID = @FundID
                              THEN 1
                              WHEN g.ToModuleID = 3
                                   AND g.ToID = @FundID
                              THEN 1
                          END
        ) AS 'PotentialProceeds'
        FROM @temp1 t
             JOIN tbl_companycontact c ON c.CompanyContactID = t.companyid
             LEFT JOIN tbl_businessarea b ON c.CompanyBusinessAreaID = b.BusinessAreaID
        WHERE t.companyid NOT IN
        (
            SELECT DISTINCT 
                   s.TargetPortfolioID
            FROM @temp1 t1
                 JOIN tbl_Shareholders S ON t1.companyid = s.TargetPortfolioID
                                            AND s.ModuleID = 5
        )
        ORDER BY t1.companyname;
    END;
