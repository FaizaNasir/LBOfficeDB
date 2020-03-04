CREATE PROCEDURE [dbo].[proc_Portfolio_GET] @vehicleID INT = NULL
AS
    BEGIN
        SELECT DISTINCT 
               CompanyContactID, 
               CompanyName, 
               KeyFigureComments, 
               p.PortfolioID
        FROM tbl_PortfolioVehicle pv
             JOIN tbl_Portfolio p ON p.PortfolioID = pv.PortfolioID
             JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
        WHERE pv.VehicleID = @vehicleID
        ORDER BY CompanyName;
    END;
