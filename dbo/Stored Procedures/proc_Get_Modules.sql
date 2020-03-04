-- [proc_Get_Modules] 2,'LbofficeAdmin'

CREATE PROCEDURE [dbo].[proc_Get_Modules] @ActiviteID INT          = NULL, 
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
               IsRead, 
               IsEdit, 
               IsCreate, 
               IsDelete, 
               IsExcel
        FROM [LBOffice].[dbo].[tbl_Modules] m
             LEFT OUTER JOIN tbl_ModuleObjectPermissions ctp ON ctp.RoleID = @RoleID
                                                                AND ctp.ModuleName LIKE '%' + m.ModuleName + '%'
        WHERE

        -- where not exists                       
        --    (                      
        --select top 1 1 from tbl_ModuleObjectPermissions ctp                      
        --  where ctp.RoleID = @RoleID and ctp.ModuleName like '%'+m.ModuleName +'%'                      
        --    ) 
        -- and 
        --(ActiviteID = ISNULL(@ActiviteID,ActiviteID)
        --or ActiviteID = 0) and 

        m.IsActive = 1
        ORDER BY OrderBy;
    END;
