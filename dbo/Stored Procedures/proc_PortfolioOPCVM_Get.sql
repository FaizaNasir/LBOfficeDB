CREATE PROC [dbo].[proc_PortfolioOPCVM_Get](@vehicleID INT)
AS
    BEGIN
        SELECT DISTINCT 
               c.CompanyName, 
               p.PortfolioID, 
               c.CompanyContactID
        FROM tbl_portfoliovehicle v
             JOIN tbl_portfolio p ON p.portfolioID = v.portfolioID
             JOIN tbl_companyContact c ON companyContactID = p.TargetPortfolioID
        WHERE VehicleID = @vehicleID
              AND v.STATUS = 5;
    END;
