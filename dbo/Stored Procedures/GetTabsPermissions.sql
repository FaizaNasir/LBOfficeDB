CREATE PROCEDURE [dbo].[GetTabsPermissions] @moduleID INT          = NULL, 
                                         @RoleID   VARCHAR(MAX) = NULL
AS
    BEGIN
        SELECT t.TabID, 
               t.ModuleID, 
               t.ActiviteID, 
               t.TabTitle, 
               t.TabDescription, 
               t.TabPageURL, 
               t.TabPageEditURL, 
               t.TabOrder, 
               t.IsConditional, 
               t.IsSelected, 
               t.IsEditable, 
               t.TabType, 
               t.CSSTag, 
               t.IsActive, 
               ISNULL(t.IsRead, 0) IsRead, 
               ISNULL(t.IsEdit, 0) IsEdit, 
               ISNULL(t.IsCreate, 0) IsCreate, 
               ISNULL(t.IsDelete, 0) IsDelete, 
               ISNULL(t.IsExcel, 0) IsExcel, 
               tp.TabsPermissionID, 
               ISNULL(tp.IsRead, 0) ReadAllowed, 
               ISNULL(tp.IsEdit, 0) EditAllowed, 
               ISNULL(tp.IsCreate, 0) CreateAllowed, 
               ISNULL(tp.IsDelete, 0) DeleteAllowed, 
               ISNULL(tp.IsExcel, 0) ExcelAllowed
        FROM [LBOffice].[dbo].[tbl_Module_Tabs] t
             LEFT JOIN tbl_TabsPermission tp ON t.ModuleID = tp.ModuleID
                                                AND tp.UserRole = @RoleID
                                                AND tp.TabID = t.TabID
                                                AND tp.SubTabID IS NULL
                                                AND SubTabID IS NULL
        WHERE t.IsActive = 1
              AND t.ModuleID = @moduleID
              AND t.tabid NOT IN(710, 718)
        ORDER BY [TabOrder];
    END;
