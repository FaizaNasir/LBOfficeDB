CREATE PROCEDURE [dbo].[proc_RolePermission_Del] --test  
@RoleName NVARCHAR(MAX)
AS
     DELETE FROM tbl_ContactTypePermission
     WHERE roleid = @RoleName;
     DELETE FROM tbl_ModuleObjectPermissions
     WHERE roleid = @RoleName;
     SELECT 1;  
