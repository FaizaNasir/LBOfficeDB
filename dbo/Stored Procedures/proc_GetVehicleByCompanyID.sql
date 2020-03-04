CREATE PROC [dbo].[proc_GetVehicleByCompanyID](@companyID INT)
AS
    BEGIN
        SELECT pv.PortfolioID, 
               pv.VehicleID
        FROM tbl_portfolio p
             JOIN tbl_portfolioVehicle pv ON pv.PortfolioID = p.PortfolioID
        WHERE TargetPortfolioID = @companyID;
    END;
