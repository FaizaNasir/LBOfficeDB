CREATE PROC [dbo].[GetHoldingCompany]
(@companyID INT, 
 @vehicleID INT
)
AS
    BEGIN
        SELECT ObjectID, 
               p.PortfolioID
        FROM tbl_ShareholdersOwned s
             JOIN tbl_Portfolio p ON s.ObjectID = p.TargetPortfolioID
                                     AND s.ModuleID = 5
             JOIN tbl_PortfolioVehicle pv ON pv.portfolioid = p.portfolioid
                                             AND pv.vehicleid = @vehicleid
        WHERE s.TargetPortfolioID = @companyID;
    END;
