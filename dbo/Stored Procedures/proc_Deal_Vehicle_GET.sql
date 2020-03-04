CREATE PROCEDURE [dbo].[proc_Deal_Vehicle_GET] @DealID INT = NULL
AS
    BEGIN
        SELECT DealVehicleId, 
               df.VehicleId, 
               DealId, 
               df.CreatedDatetime, 
               Name
        FROM [tbl_DealVehicle] df
             JOIN tbl_vehicle f ON f.VehicleID = df.VehicleID
        WHERE df.DealID = ISNULL(@DealID, df.DealID);
    END;
