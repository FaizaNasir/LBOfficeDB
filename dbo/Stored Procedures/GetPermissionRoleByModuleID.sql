CREATE PROC [dbo].[GetPermissionRoleByModuleID](@moduleID INT)
AS
    BEGIN
        SELECT DISTINCT 
               RoleName UserRole
        FROM aspnet_Roles r
        WHERE EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_TabsPermission p
            WHERE ModuleID = 12
                  AND p.UserRole = r.RoleName
                  AND IsRead = 1
        );
    END;
