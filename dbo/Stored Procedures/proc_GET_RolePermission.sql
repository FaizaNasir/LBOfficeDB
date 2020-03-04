CREATE PROCEDURE [dbo].[proc_GET_RolePermission] @rolename VARCHAR(MAX) = NULL
AS
    BEGIN
        SELECT r.rolename,
               CASE
                   WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM dbo.tbl_ContactTypePermission c
            WHERE c.roleid = r.RoleName
                  AND moduleid = 4
        )
                        AND EXISTS
        (
            SELECT TOP 1 1
            FROM dbo.tbl_ModuleObjectPermissions c
            WHERE c.roleid = r.RoleName
                  AND moduleid = 4
        )
                   THEN 'Yes'
                   ELSE 'No'
               END IsIndivisual,
               CASE
                   WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM dbo.tbl_ContactTypePermission c
            WHERE c.roleid = r.RoleName
                  AND moduleid = 5
        )
                        AND EXISTS
        (
            SELECT TOP 1 1
            FROM dbo.tbl_ModuleObjectPermissions c
            WHERE c.roleid = r.RoleName
                  AND moduleid = 5
        )
                   THEN 'Yes'
                   ELSE 'No'
               END IsCompany
        FROM dbo.aspnet_Roles r
        WHERE r.RoleName = ISNULL(@rolename, r.RoleName);
    END;
