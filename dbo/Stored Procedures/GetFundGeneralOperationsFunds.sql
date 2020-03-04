CREATE PROC [dbo].[GetFundGeneralOperationsFunds](@vehicleID INT)
AS
    BEGIN
        SELECT DISTINCT 
               v.VehicleID, 
               v.Name AS VehicleName
        FROM tbl_PortfolioFundGeneralOperation sho
             JOIN tbl_vehicle v ON 1 = CASE
                                           WHEN sho.FromModuleID = 3
                                                AND sho.FromID = v.VehicleID
                                           THEN 1
                                           WHEN sho.ToModuleID = 3
                                                AND sho.ToID = v.VehicleID
                                           THEN 1
                                           ELSE 0
                                       END
        WHERE sho.vehicleID = @vehicleID
              AND v.vehicleid <> @vehicleID
        ORDER BY v.Name;
    END;
