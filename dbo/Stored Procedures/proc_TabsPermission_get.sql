CREATE PROC [dbo].[proc_TabsPermission_get]
(@moduleID INT, 
 @tabID    INT, 
 @subtabID INT, 
 @roleName VARCHAR(1000)
)
AS
    BEGIN
        SELECT TabsPermissionID, 
               ModuleID, 
               TabID, 
               SubTabID, 
               UserRole, 
               IsRead, 
               IsEdit, 
               IsCreate, 
               IsDelete, 
               IsExcel, 
               Active, 
               CreateDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_TabsPermission
        WHERE ModuleID = ISNULL(@moduleID, ModuleID)
              AND TabID = ISNULL(@moduleID, TabID)
              AND SubTabID = ISNULL(@moduleID, SubTabID)
              AND UserRole = ISNULL(@moduleID, UserRole);
    END;
