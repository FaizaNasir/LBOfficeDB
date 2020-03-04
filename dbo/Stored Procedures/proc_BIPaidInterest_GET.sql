CREATE PROCEDURE [dbo].[proc_BIPaidInterest_GET]
AS
    BEGIN
        SELECT cc.CompanyName AS 'Company name', 
               s.Date, 
               SUM(s.amount) AS 'Paid Interest'
        FROM tbl_Portfolio p
             INNER JOIN tbl_PortfolioVehicle pv ON p.PortfolioID = pv.PortfolioVehicleID
             INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
             INNER JOIN tbl_PortfolioGeneralOperation s ON toModuleID = 3
                                                           AND toid = 28
                                                           AND s.PortfolioID = p.portfolioid
                                                           AND typeid = 2
                                                           AND DATE <= GETDATE()
                                                           AND IsConditional = 0
        WHERE pv.VehicleID = 28
        GROUP BY s.Date, 
                 cc.CompanyName;
    END;
