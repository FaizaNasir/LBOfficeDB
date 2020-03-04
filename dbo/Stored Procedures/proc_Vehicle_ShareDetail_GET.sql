CREATE PROCEDURE [dbo].[proc_Vehicle_ShareDetail_GET] @VehicleID INT, 
                                                     @shareID   INT
AS
    BEGIN
        SELECT VehicleShareDetailID, 
               VehicleID, 
               ShareDate, 
               NominalValue, 
               CreatedDateTime, 
               CreatedBy, 
               ModifiedDateTime, 
               ModifiedBy, 
               Active, 
               ShareID
        FROM tbl_VehicleShareDetail
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID)
              AND ShareID = ISNULL(@shareID, ShareID)
        ORDER BY ShareDate DESC;
    END;
