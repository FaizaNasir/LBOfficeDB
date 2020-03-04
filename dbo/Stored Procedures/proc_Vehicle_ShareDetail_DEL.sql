CREATE PROCEDURE [dbo].[proc_Vehicle_ShareDetail_DEL] @VehicleID INT
AS
    BEGIN
        DELETE FROM [tbl_VehicleShareDetail]
        WHERE ShareID = @VehicleID;
        SELECT 1 'Column1';
    END;
