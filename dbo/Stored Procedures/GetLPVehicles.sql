CREATE PROC [dbo].[GetLPVehicles]
(@moduleid INT, 
 @objectid INT, 
 @role     VARCHAR(1000)
)
AS
    BEGIN
        SELECT DISTINCT 
               v.name VehicleName, 
               v.VehicleID
        FROM tbl_LimitedPartner lp
             JOIN tbl_vehicle v ON v.vehicleID = lp.vehicleID
        WHERE moduleid = @moduleid
              AND objectID = @objectid
              AND NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_BlockedPermission
            WHERE userrole = @role
                  AND modulename = 'Funds'
                  AND lp.vehicleID = ObjectID
        )
        ORDER BY v.name;
    END;
