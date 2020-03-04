CREATE PROC [dbo].[GetLPTemplateConfigDetailPortal]
(@vehicleID INT, 
 @objectID  INT, 
 @moduleID  INT
)
AS
    BEGIN
        SELECT lpd.LPTemplateConfigDetailID, 
               lp.LPTemplateConfigID, 
               ModuleID, 
               ObjectID, 
               lp.Active, 
               lp.CreatedDate, 
               lp.ModifiedDate, 
               lp.CreatedBy, 
               lp.ModifiedBy, 
               dbo.F_GetObjectModuleName(ObjectID, ModuleID) ObjectName, 
               DownloadedDate, 
               lp.DocumentTypeID, 
               lp.Name, 
               FileName
        FROM tbl_LPTemplateConfigDetail lpd
             JOIN tbl_LPTemplateConfig lp ON lp.LPTemplateConfigID = lpd.LPTemplateConfigID
        WHERE ObjectID = @ObjectID
              AND ModuleID = @moduleID;
        --and lp.VehicleID = @vehicleID
        --and lp.DocumentTypeID = 6
    END;
