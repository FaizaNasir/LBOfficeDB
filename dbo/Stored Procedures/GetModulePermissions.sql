-- [GetModulePermissions] 2,'Back office group'

CREATE PROCEDURE [dbo].[GetModulePermissions] @ActiviteID INT          = NULL, 
                                              @RoleID     VARCHAR(MAX) = NULL
AS
    BEGIN
        SELECT m.[ModuleID], 
               [ActiviteID], 
               m.[ModuleName], 
               [ModuleDesc], 
               [ModuleURL], 
               [IsSelected], 
               [CssTag], 
               [IsActive], 
               [CreatedDateTime], 
               [orderby], 
               ISNULL(m.IsRead, 0) IsRead, 
               ISNULL(m.IsEdit, 0) IsEdit, 
               ISNULL(m.IsCreate, 0) IsCreate, 
               ISNULL(m.IsDelete, 0) IsDelete, 
               ISNULL(m.IsExcel, 0) IsExcel, 
               tp.TabsPermissionID, 
               ISNULL(tp.IsRead, 0) ReadAllowed, 
               ISNULL(tp.IsEdit, 0) EditAllowed, 
               ISNULL(tp.IsCreate, 0) CreateAllowed, 
               ISNULL(tp.IsDelete, 0) DeleteAllowed, 
               ISNULL(tp.IsExcel, 0) ExcelAllowed
        FROM [LBOffice].[dbo].[tbl_Modules] m
             LEFT JOIN tbl_TabsPermission tp ON m.ModuleID = tp.ModuleID
                                                AND tp.UserRole = @RoleID
                                                AND TabID IS NULL
                                                AND SubTabID IS NULL
        WHERE m.IsActive = 1
        ORDER BY OrderBy;
    END;
