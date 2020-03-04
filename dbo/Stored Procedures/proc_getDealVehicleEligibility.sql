CREATE PROC [dbo].[proc_getDealVehicleEligibility] @dealID INT
AS
    BEGIN
        SELECT VehicleID
        FROM tbl_dealVehicleeligibility
        WHERE dealid = @dealid;
    END;
