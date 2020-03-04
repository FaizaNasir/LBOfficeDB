-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[proc_Get_Modules_Sub_Tab]

-- Add the parameters for the stored procedure here

@TabID      INT, 
@ActiviteID INT = NULL
AS
    BEGIN
        SELECT [SubTabID], 
               [TabID], 
               [ActiviteID], 
               [SubTabTitle], 
               [SubTabDesc], 
               [SubTabPageURL], 
               [SubTabPageEditURL], 
               [SubTabOrder], 
               [IsConditional], 
               [IsSelected], 
               [IsEditable], 
               [CSSTag], 
               [IsActive], 
               [CreatedDateTime], 
               ISNULL(IsRead, 0) IsRead, 
               ISNULL(IsEdit, 0) IsEdit, 
               ISNULL(IsCreate, 0) IsCreate, 
               ISNULL(IsDelete, 0) IsDelete, 
               ISNULL(IsExcel, 0) IsExcel
        FROM [LBOffice].[dbo].[tbl_Module_Sub_Tabs]
        WHERE TabID = @TabID
              AND isactive = 1

        --and (ActiviteID = ISNULL(@ActiviteID,ActiviteID) or ActiviteID = 0)

        ORDER BY SubTabOrder;
    END;
