CREATE PROCEDURE [dbo].[GetSubTabsPermissions] @tabID  INT          = NULL, 
                                               @RoleID VARCHAR(MAX) = NULL
AS
    BEGIN
        SELECT st.SubTabID, 
               st.TabID, 
               st.ActiviteID, 
               st.SubTabTitle, 
               st.SubTabDesc, 
               st.SubTabPageURL, 
               st.SubTabPageEditURL, 
               st.SubTabOrder, 
               st.IsConditional, 
               st.IsSelected, 
               st.IsEditable, 
               st.CSSTag, 
               st.IsActive, 
               st.CreatedDateTime, 
               ISNULL(st.IsRead, 0) IsRead, 
               ISNULL(st.IsEdit, 0) IsEdit, 
               ISNULL(st.IsCreate, 0) IsCreate, 
               ISNULL(st.IsDelete, 0) IsDelete, 
               ISNULL(st.IsExcel, 0) IsExcel, 
               tp.TabsPermissionID, 
               ISNULL(tp.IsRead, 0) ReadAllowed, 
               ISNULL(tp.IsEdit, 0) EditAllowed, 
               ISNULL(tp.IsCreate, 0) CreateAllowed, 
               ISNULL(tp.IsDelete, 0) DeleteAllowed, 
               ISNULL(tp.IsExcel, 0) ExcelAllowed
        FROM [LBOffice].[dbo].[tbl_Module_Sub_Tabs] st
             LEFT JOIN tbl_TabsPermission tp ON tp.ModuleID IS NOT NULL
                                                AND tp.UserRole = @RoleID
                                                AND tp.TabID = st.TabID
                                                AND st.SubTabID = tp.SubTabID
        WHERE st.IsActive = 1
              AND st.tabid = @tabid
              AND st.SubTabID NOT IN(7024, 7025, 7038, 12, 7026, 7039, 7023, 7027)
        ORDER BY SubTabOrder;
    END;
