CREATE PROC [dbo].[GetBlockedGroupPermission](@userRole VARCHAR(100))
AS
    BEGIN
        SELECT BlockedGroupPermissionID, 
               ModuleID, 
               TypeID, 
               UserRole, 
               Active, 
               CreateDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_BlockedGroupPermission
        WHERE UserRole = @userRole;
    END;
