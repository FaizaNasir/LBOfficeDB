CREATE PROCEDURE [dbo].[proc_GET_Menus] @RoleID INT, 
                                        @MenuID INT = NULL
AS
    BEGIN
        SELECT M.*
        FROM tbl_Menus M
             LEFT JOIN dbo.tbl_MenuPermissions MP ON M.MenuID = MP.MenuID
                                                     AND MP.RoleID = @RoleID
        WHERE MP.MenuID IS NULL
              AND M.MenuID = ISNULL(@MenuID, M.MenuID)
        ORDER BY M.MenuOrder;
    END;
