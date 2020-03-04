CREATE PROCEDURE [dbo].[proc_GET_MenuTabs] @RoleID INT, 
                                           @MenuID INT, 
                                           @TabID  INT = NULL
AS
    BEGIN
        SELECT *
        FROM tbl_MenuTabs T
             INNER JOIN tbl_Menus M ON M.MenuID = T.MenuID
             LEFT JOIN tbl_MenuTabPermissions P ON T.TabID = P.TabID
                                                   AND P.RoleID = @RoleID
        WHERE T.MenuID = ISNULL(@MenuID, T.MenuID)
              AND P.TabID IS NULL
              AND T.TabID = ISNULL(@TabID, T.TabID);
    END;
