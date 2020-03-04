CREATE FUNCTION [dbo].[FnGetHoldingCompanies]
(@vehicleID INT
)
RETURNS @RtnValue TABLE(Value INT)
AS
     BEGIN
         INSERT INTO @RtnValue
                SELECT p.portfolioID
                FROM tbl_portfoliovehicle pv
                     JOIN tbl_portfolio p ON p.portfolioid = pv.portfolioid
                     JOIN tbl_companycontact cc ON cc.companycontactid = p.TargetPortfolioID
                WHERE pv.VehicleID = @vehicleID
                      AND NOT EXISTS
                (
                    SELECT TOP 1 1
                    FROM tbl_ShareholdersOwned so
                    WHERE so.objectid = p.TargetPortfolioID
                          AND so.moduleid = 5
                )
                UNION ALL
                SELECT DISTINCT 
                       pp.PortfolioID
                FROM
                (
                    SELECT p.portfolioID, 
                           TargetPortfolioID
                    FROM tbl_portfoliovehicle pv
                         JOIN tbl_portfolio p ON p.portfolioid = pv.portfolioid
                    WHERE pv.VehicleID = @vehicleID
                          AND NOT EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_ShareholdersOwned so
                        WHERE so.objectid = p.TargetPortfolioID
                              AND so.moduleid = 5
                    )
                ) t
                JOIN tbl_ShareholdersOwned so ON so.targetportfolioid = t.TargetPortfolioID
                                                 AND moduleid = 5
                JOIN tbl_portfolio pp ON pp.TargetPortfolioID = so.ObjectID;
         RETURN;
     END;
