
-- Select  [dbo].[F_SumOfAmountInvested_ByFund_PortfolioGrid](28)  

CREATE FUNCTION [dbo].[F_SumOfAmountInvested_ByFund_PortfolioGrid]
(@vehicleid INT
)
RETURNS DECIMAL(18, 2)
AS
     BEGIN
         DECLARE @result DECIMAL(18, 2);
         DECLARE @tmp TABLE(amountinvested DECIMAL(18, 2));
         INSERT INTO @tmp
                SELECT
                (
                    SELECT ISNULL(SUM(Amount), 0)
                    FROM tbl_PortfolioShareholdingOperations
                    WHERE ToTypeID = 3
                          AND ToID = @vehicleid
                          AND PortfolioID = p.PortfolioID
                          AND isConditional = 0
                ) +
                (
                    SELECT ISNULL(SUM(pgo.amount), 0)
                    FROM tbl_PortfolioGeneralOperation pgo
                    WHERE pgo.FromModuleID = 3
                          AND pgo.FromID = @vehicleid
                          AND pgo.TypeID = 5
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
                    ) = 3
                                     THEN ISNULL(SUM(pfp.AmountDue * -1), 0)
                                     ELSE ISNULL(SUM(pfp.AmountDue), 0)
                                 END
                    FROM tbl_PortfolioFollowOnPayment pfp
                         INNER JOIN tbl_PortfolioShareholdingOperations pso ON pso.ShareholdingOperationID = pfp.ShareholdingOperationID
                    WHERE pso.PortfolioID = p.portfolioid
                          AND isConditional = 0
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
                          AND g.fromID = @vehicleid
                          AND TypeID = 9
                ) AS 'AmountInvested'
                FROM tbl_PortfolioVehicle pv
                     JOIN tbl_Portfolio p ON pv.PortfolioID = p.PortfolioID
                     JOIN tbl_companycontact c ON c.CompanyContactID = p.TargetPortfolioID
                     LEFT JOIN tbl_businessarea b ON c.CompanyBusinessAreaID = b.BusinessAreaID
                WHERE VehicleID = @vehicleid
                      AND STATUS IN(1, 2, 3)
                ORDER BY c.CompanyName;
         SELECT @result =
         (
             SELECT SUM(amountinvested)
             FROM @tmp
         );
         RETURN @result;
     END; 
