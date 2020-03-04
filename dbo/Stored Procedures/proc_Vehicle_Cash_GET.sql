CREATE PROCEDURE [dbo].[proc_Vehicle_Cash_GET] @VehicleID INT = NULL
AS
    BEGIN
        SELECT [VehicleCashID], 
               [VehicleID], 
               [Amount], 
               [Currency], 
               [Date], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy], 
               [Active]
        FROM tbl_VehicleCash
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID)
        ORDER BY [Date] DESC;
    END;
