CREATE PROCEDURE [dbo].[proc_Vehicle_Cash_DEL] @VehicleCashID INT
AS
     DELETE FROM tbl_VehicleCash
     WHERE VehicleCashID = @VehicleCashID;
     SELECT 1 AS 'Result';
