
-- proc_ExitsGrid_ExportExcel 28                   

CREATE PROC [dbo].[proc_ExitsGrid_ExportExcel]
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
            SELECT TOP 1 InvestmentValue
            FROM tbl_PortfolioValuation pso
            WHERE pso.PortfolioID = p.PortfolioID
                  AND pso.VehicleID = pv.VehicleID
                  AND date <= @date
            ORDER BY Date DESC
        ) 'InvestmentValue', 
        (
            SELECT [dbo].[F_capitaltable_Report](@date, c.CompanyContactID, p.PortfolioID)
        ) AS 'Owned', 
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @FundID
                  AND PortfolioID = p.PortfolioID
                  AND date <= @date
                  AND isConditional = 0
        ) + ISNULL(
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
            WHERE pso.PortfolioID = p.PortfolioID
                  AND isConditional = 0
                  AND pfp.date <= @date
                  AND pso.date <= @date
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
                  AND date <= @date
        ) AS 'AmountInvested', 
               CAST(pv.Amount * 100.0 /
        (
            SELECT SUM(cc.Amount)
            FROM tbl_PortfolioVehicle cc
            WHERE cc.VehicleID = @fundiD
        ) AS DECIMAL(18, 2)) 'PortfolioWeight', 
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
                  AND TypeID = 4
                  AND date <= @date
        ) AS 'GeneralDividends', 
        (
            SELECT SUM(Amount)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND g.IsConditional = 0
                  AND TypeID = 2
                  AND date <= @date
        ) AS 'GeneralInterestIncome', 
        (
            SELECT SUM(ISNULL(pgo.amount, 0))
            FROM tbl_PortfolioGeneralOperation pgo
            WHERE pgo.FromModuleID = 3
                  AND pgo.FromID = @fundiD
                  AND pgo.TypeID = 1
                  AND pgo.PortfolioID = p.PortfolioID
                  AND isConditional = 0
                  AND date <= @date
        ) AS 'GeneralAcquisitionFees', 
        (
            SELECT SUM(Amount)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND g.IsConditional = 0
                  AND TypeID = 6
                  AND date <= @date
        ) AS 'GeneralExitFees', 
               CAST(
        (
            SELECT TOP 1 YEAR(Date)
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.FromID = @fundiD
                  AND pso.FromTypeID = 3
                  AND pso.PortfolioID = p.PortfolioID
                  AND date <= @date
            ORDER BY Date DESC
        ) -
        (
            SELECT TOP 1 YEAR(Date)
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.ToID = @fundiD
                  AND pso.ToTypeID = 3
                  AND pso.PortfolioID = p.PortfolioID
                  AND date <= @date
            ORDER BY Date ASC
        ) + ((
        (
            SELECT TOP 1 MONTH(Date)
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.FromID = @fundiD
                  AND pso.PortfolioID = p.PortfolioID
                  AND date <= @date
                  AND pso.FromTypeID = 3
            ORDER BY Date DESC
        ) -
        (
            SELECT TOP 1 MONTH(Date)
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.ToID = @fundiD
                  AND pso.PortfolioID = p.PortfolioID
                  AND date <= @date
                  AND pso.ToTypeID = 3
            ORDER BY Date ASC
        )) * 1.0 / 12) AS DECIMAL(18, 2)) 'Durationinportfolio', 
               ((
        (
            SELECT ISNULL(SUM(pso.amount), 0)
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.fromid = @fundiD
                  AND pso.FromTypeID = 3
                  AND pso.portfolioid = p.PortfolioID
                  AND date <= @date
                  AND isConditional = 0
        ) +
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND date <= @date
                  AND g.IsConditional = 0
                  AND TypeID IN(1, 2)
        )) -
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND g.IsConditional = 0
                  AND date <= @date
                  AND TypeID IN(5, 6)
        )) AS 'Proceeds', 
               (((
        (
            SELECT ISNULL(SUM(pso.amount), 0)
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.fromid = @fundiD
                  AND pso.FromTypeID = 3
                  AND date <= @date
                  AND pso.portfolioid = p.PortfolioID
                  AND isConditional = 0
        ) +
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND date <= @date
                  AND g.IsConditional = 0
                  AND TypeID IN(1, 2)
        )) -
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioGeneralOperation g
            WHERE g.PortfolioID = p.PortfolioID
                  AND date <= @date
                  AND g.IsConditional = 0
                  AND TypeID IN(5, 6)
        )) /
        (
            SELECT CASE
                       WHEN SUM(Amount) = 0
                       THEN 1
                       ELSE SUM(Amount)
                   END
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @fundiD
                  AND PortfolioID = pv.PortfolioID
                  AND isConditional = 0
                  AND date <= @date
        )) AS 'Multiple', 
        (
            SELECT TOP 1 Date
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.FromID = @fundiD
                  AND pso.FromTypeID = 3
                  AND pso.PortfolioID = p.PortfolioID
                  AND date <= @date
            ORDER BY Date DESC
        ) AS 'Exitdate', 
        (
            SELECT ISNULL(SUM(Amount), 0)
            FROM tbl_PortfolioShareholdingOperations
            WHERE FromTypeID = 3
                  AND FromID = @FundID
                  AND PortfolioID = p.PortfolioID
                  AND isConditional = 0
                  AND date <= @date
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
                  AND date <= @date
                  AND TypeID = 9
        ) AS 'Divestment'
        FROM tbl_PortfolioVehicle pv
             JOIN tbl_Portfolio p ON pv.PortfolioID = p.PortfolioID
             JOIN tbl_companycontact c ON c.CompanyContactID = p.TargetPortfolioID
             LEFT JOIN tbl_businessarea b ON c.CompanyBusinessAreaID = b.BusinessAreaID
        WHERE VehicleID = @fundiD
              AND STATUS = 4
        ORDER BY c.CompanyName;
    END;
