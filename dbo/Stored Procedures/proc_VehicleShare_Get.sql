CREATE PROC [dbo].[proc_VehicleShare_Get]
(@vehicleID      INT, 
 @VehicleShareID INT
)
AS
    BEGIN
        SELECT VehicleShareID, 
               VehicleID, 
               ShareName, 
               ShareNameFr, 
        (
            SELECT TOP 1 a.NominalValue
            FROM tbl_vehicleshareDetail a
            WHERE a.VehicleID = @VehicleID
                  AND a.ShareID = v.VehicleShareID
            ORDER BY a.ShareDate DESC
        ) NominalValue, 
               Hurdle, 
               Catchup, 
               CarriedInterest, 
               Notes, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy, 
               IsinA, 
               IncludedReport, 
               ExportChart
        FROM tbl_vehicleshare v
        WHERE v.vehicleID = @vehicleID
              AND v.VehicleShareID = ISNULL(@VehicleShareID, v.VehicleShareID);
    END;
