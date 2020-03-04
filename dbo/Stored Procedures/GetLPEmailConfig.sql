CREATE PROC [dbo].[GetLPEmailConfig]
(@moduleID  INT, 
 @objectID  INT, 
 @vehicleID INT
)
AS
    BEGIN
        SELECT ISNULL(LPEmailConfigID, 0) LPEmailConfigID, 
               ModuleID, 
               DocumentTypeName, 
               ObjectID, 
               vdt.VehicleID, 
               vdt.DocumentTypeID, 
               ToEmailAddress, 
               CCEmailAddress, 
               vdt.Active, 
               vdt.CreatedDate, 
               vdt.ModifiedDate, 
               vdt.CreatedBy, 
               vdt.ModifiedBy, 
               dbo.[F_GetLPEmailConfigDetail](LPEmailConfigID, 0) ToContacts, 
               dbo.[F_GetLPEmailConfigDetail](LPEmailConfigID, 1) CCContacts
        FROM tbl_vehicledocumenttype vdt
             JOIN tbl_DocumentType dt ON dt.DocumentTypeID = vdt.DocumentTypeID
             LEFT JOIN tbl_LPEmailConfig ec ON vdt.Vehicleid = ec.VehicleID
                                               AND ec.DocumentTypeID = vdt.DocumentTypeID
                                               AND moduleID = @moduleID
                                               AND objectid = @objectID
        WHERE vdt.vehicleID = @vehicleID
              AND vdt.active = 1;
    END;
