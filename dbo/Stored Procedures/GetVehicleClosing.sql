CREATE PROC [dbo].[GetVehicleClosing](@VehicleID INT)
AS
    BEGIN
        SELECT VehicleClosingID, 
               StartDate, 
               EndDate, 
               VehicleID, 
               Number, 
               Notes, 
               Active, 
               CreatedDate, 
               ModifiedDate, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_VehicleClosing
        WHERE VehicleID = @VehicleID;
    END;
