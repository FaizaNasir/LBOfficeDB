CREATE PROCEDURE [dbo].[proc_GET_UserControlPermissions] @RoleID    INT, 
                                                         @ControlID INT
AS
    BEGIN
        SELECT *
        FROM tbl_MenuTabsUserControl UC
             LEFT JOIN tbl_UserControlPermissions UP ON UC.UserControlID = UP.UserControlID
                                                        AND UP.RoleID = @RoleID
        WHERE UP.UserControlID IS NULL;
    END;
