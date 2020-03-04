
CREATE PROCEDURE [dbo].[proc_Portfolio_Vehicle_GET] @PortfolioID INT = NULL
AS
    BEGIN
        SELECT a.VehicleID, 
               b.Name, 
               a.[Status]
        FROM tbl_PortfolioVehicle a
             JOIN tbl_Vehicle b ON a.VehicleID = b.VehicleID
        WHERE PortfolioID = @PortfolioID;
    END;
