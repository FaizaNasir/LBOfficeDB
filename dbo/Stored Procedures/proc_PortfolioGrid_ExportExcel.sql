
-- proc_PortfolioGrid_ExportExcel 66                       

CREATE PROC [dbo].[proc_PortfolioGrid_ExportExcel]
(@fundiD   INT, 
 @userrole VARCHAR(100), 
 @date     DATETIME
)
AS
    BEGIN
        SELECT p.PortfolioID, 
               c.CompanyContactID, 
               c.CompanyName 'ComapanyName', 
               b.BusinessAreaTitle 'Sector', 
        (
            SELECT TOP 1 pso.Date
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.ToID = @fundiD
                  AND pso.PortfolioID = p.PortfolioID
                  AND pso.ToTypeID = 3
                  AND date <= @date
            ORDER BY Date
        ) 'InvestmentDate', 
        (
            SELECT TOP 1 FinalValuation
            FROM tbl_PortfolioValuation pso
            WHERE pso.PortfolioID = p.PortfolioID
                  AND pso.VehicleID = pv.VehicleID
                  AND date <= @date
            ORDER BY Date DESC
        ) 'InvestmentValue', 
        (
            SELECT [dbo].[F_capitaltable_Report](@date, c.CompanyContactID, p.PortfolioID)
        ) AS 'Owned', 
               CAST(
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @FundID
                  AND PortfolioID = p.PortfolioID
                  AND ISNULL(isConditional, 0) = 0
                  AND tbl_PortfolioShareholdingOperations.Date <= @date
        ) AS DECIMAL(18, 2)) + CAST(ISNULL(
        (
            SELECT TOP 1 CASE
                             WHEN
            (
                SELECT FromTypeID
                FROM tbl_PortfolioShareholdingOperations s
                WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
                      AND s.date <= @date
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
                  AND pso.Date <= @date
            GROUP BY pfp.ShareholdingOperationID
        ), 0) AS DECIMAL(18, 2)) + CAST(
        (
            SELECT ISNULL(SUM(CASE
                                  WHEN TypeID IN(1, 3, 7, 8)
                                  THEN Amount
                              END), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND ISNULL(g.isConditional, 0) = 0
                  AND 1 = CASE
                              WHEN g.fromID = @FundID
                                   AND g.FromModuleID = 3
                              THEN 1
                              WHEN g.toID = @FundID
                                   AND g.toModuleID = 3
                              THEN 1
                          END
                  AND g.Date <= @date
        ) AS DECIMAL(18, 2)) AS 'AmountInvested', 
               ((
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @FundID
                  AND PortfolioID = p.PortfolioID
                  AND Date <= @date
                  AND isConditional = 0
        ) +
        (
            SELECT ISNULL(SUM(pgo.amount), 0)
            FROM tbl_PortfolioGeneralOperation pgo
            WHERE pgo.FromModuleID = 3
                  AND pgo.FromID = @FundID
                  AND pgo.TypeID = 5
                  AND Date <= @date
                  AND pgo.PortfolioID = p.portfolioid
                  AND isConditional = 0
        ) + ISNULL(
        (
            SELECT TOP 1 CASE
                             WHEN
            (
                SELECT FromTypeID
                FROM tbl_PortfolioShareholdingOperations s
                WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
                      AND s.Date <= @date
            ) = 3
                             THEN ISNULL(SUM(pfp.AmountDue * -1), 0)
                             ELSE ISNULL(SUM(pfp.AmountDue), 0)
                         END
            FROM tbl_PortfolioFollowOnPayment pfp
                 INNER JOIN tbl_PortfolioShareholdingOperations pso ON pso.ShareholdingOperationID = pfp.ShareholdingOperationID
            WHERE pso.PortfolioID = p.portfolioid
                  AND isConditional = 0
                  AND pfp.Date <= @date
                  AND pso.Date <= @date
            GROUP BY pfp.ShareholdingOperationID
        ), 0) +
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND g.IsConditional = 0
                  AND g.toID = p.TargetPortfolioID
                  AND g.toModuleID = 5
                  AND g.FromModuleID = 3
                  AND g.fromID = @FundID
                  AND TypeID = 9
                  AND g.Date <= @date
        )) / [dbo].[F_SumOfAmountInvested_ByFund_PortfolioGrid](@fundiD)) * 100 'PortfolioWeight', 
               c.CompanyBusinessDesc 'CompanyComments', 
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND g.IsConditional = 0
                  AND g.FromID = p.TargetPortfolioID
                  AND g.FromModuleID = 5
                  AND g.ToModuleID = 3
                  AND g.ToID = @fundiD
                  AND g.Date <= @date
                  AND TypeID = 4
        ) AS 'GeneralDividends', 
        (
            SELECT SUM(Amount)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND g.IsConditional = 0
                  AND TypeID = 5
                  AND g.Date <= @date
        ) AS 'GeneralInterestIncome', 
        (
            SELECT SUM(ISNULL(pgo.amount, 0))
            FROM tbl_PortfolioGeneralOperation pgo
            WHERE pgo.FromModuleID = 3
                  AND pgo.FromID = @fundiD
                  AND pgo.TypeID = 1
                  AND pgo.PortfolioID = p.PortfolioID
                  AND isConditional = 0
                  AND pgo.Date <= @date
        ) AS 'GeneralAcquisitionFees', 
        (
            SELECT SUM(Amount)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND g.IsConditional = 0
                  AND g.Date <= @date
                  AND TypeID = 6
        ) AS 'GeneralExitFees', 
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioShareholdingOperations
            WHERE FromTypeID = 3
                  AND FromID = @FundID
                  AND PortfolioID = p.PortfolioID
                  AND isConditional = 0
                  AND Date <= @date
        ) +
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND g.IsConditional = 0
                  AND g.FromID = p.TargetPortfolioID
                  AND g.FromModuleID = 5
                  AND g.ToModuleID = 3
                  AND g.toID = @FundID
                  AND TypeID = 9
                  AND g.Date <= @date
        ) AS 'Divestment'
        FROM tbl_PortfolioVehicle pv
             JOIN tbl_Portfolio p ON pv.PortfolioID = p.PortfolioID
             JOIN tbl_companycontact c ON c.CompanyContactID = p.TargetPortfolioID
             LEFT JOIN tbl_businessarea b ON c.CompanyBusinessAreaID = b.BusinessAreaID
        WHERE VehicleID = @fundiD
              AND STATUS IN(1, 2, 3)
        ORDER BY c.CompanyName;
    END;
