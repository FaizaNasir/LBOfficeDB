
CREATE PROC [dbo].[GetAssociatedLP]  
(@vehicleID       INT,   
 @currentModuleID INT,   
 @currentObjectID INT  
)  
AS  
    BEGIN  
        SELECT AssociatedLPID,   
               ModuleID,   
               ObjectID,   
               VehicleID,   
               dbo.F_GetObjectModuleName(objectID, ModuleID) ObjectName,   
               IsMain,   
               CreatedBy,   
               CreatedDate,   
               ModifiedBy,   
               ModifiedDate,   
               Currentmoduleid CurrentobjectID  
        FROM tbl_associatedlp  
        WHERE vehicleid = @vehicleid  
              AND currentmoduleid = @currentmoduleid  
              AND currentobjectID = @currentobjectID
			  and objectid is not null and moduleid is not null
    END;  
