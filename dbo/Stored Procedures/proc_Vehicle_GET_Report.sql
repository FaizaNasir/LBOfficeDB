CREATE PROCEDURE [dbo].[proc_Vehicle_GET_Report] @UserName VARCHAR(100) = NULL
AS
    BEGIN
        DECLARE @RoleName VARCHAR(100);
        DECLARE @varUserName VARCHAR(100);
        SET @RoleName = '';
        SET @varUserName = '';
        SET @varUserName = RIGHT(@UserName, CHARINDEX('|', REVERSE('|' + @UserName)) - 1);
        SELECT @RoleName = R.RoleName
        FROM aspnet_UsersInRoles AS UR
             INNER JOIN aspnet_Roles AS R ON UR.RoleId = R.RoleId
             INNER JOIN aspnet_Users AS U ON UR.UserId = U.UserId
        WHERE U.UserName = @varUserName;
        SELECT V.[VehicleID], 
               V.[Name], 
               V.Active
        FROM tbl_Vehicle V
        WHERE V.VehicleID NOT IN
        (
            SELECT ModuleObjectID
            FROM tbl_ModuleObjectPermissions mbp
            WHERE mbp.noaccess = 1
                  AND mbp.ModuleName = 'Fund'
                  AND mbp.RoleID = @RoleName
        )
              AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_tabspermission
            WHERE moduleID = 3
                  AND TabID IS NULL
                  AND SubTabID IS NULL
                  AND UserRole = @RoleName
                  AND IsRead = 1
        )
              AND NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_BlockedPermission b
            WHERE b.moduleName = 'Funds'
                  AND UserRole = @RoleName
                  AND b.ObjectID = VehicleID
        )
        ORDER BY Name;
    END;
