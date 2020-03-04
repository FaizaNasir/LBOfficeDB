CREATE PROCEDURE [dbo].[proc_RoleNameByUserName_GET] @UserName VARCHAR(MAX)
AS
    BEGIN
        SELECT R.RoleName, 
               U.UserName
        FROM aspnet_UsersInRoles AS UR
             INNER JOIN aspnet_Roles AS R ON UR.RoleId = R.RoleId
             INNER JOIN aspnet_Users AS U ON UR.UserId = U.UserId
        WHERE U.UserName = @UserName;
    END;
