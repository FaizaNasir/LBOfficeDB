CREATE PROCEDURE [dbo].[proc_Get_Module_Tabs] @ModuleID   INT, 
                                              @ActiviteID INT = NULL
AS
    BEGIN
        SELECT [TabID], 
               [ModuleID], 
               [ActiviteID], 
               [TabTitle], 
               [TabDescription], 
               [TabPageURL], 
               [TabPageEditURL], 
               [TabOrder], 
               [IsConditional], 
               [IsSelected], 
               [IsEditable], 
               [TabType], 
               [CSSTag], 
               [IsActive], 
               ISNULL(IsRead, 0) IsRead, 
               ISNULL(IsEdit, 0) IsEdit, 
               ISNULL(IsCreate, 0) IsCreate, 
               ISNULL(IsDelete, 0) IsDelete, 
               ISNULL(IsExcel, 0) IsExcel
        FROM [LBOffice].[dbo].[tbl_Module_Tabs]
        WHERE ModuleID = @ModuleID
              AND isactive = 1

        --and  (ActiviteID = ISNULL(@ActiviteID,ActiviteID)or ActiviteID = 0)

        ORDER BY [TabOrder];
    END;
