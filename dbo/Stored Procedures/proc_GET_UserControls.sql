CREATE PROCEDURE [dbo].[proc_GET_UserControls] @MenuID INT, 
                                               @TabID  INT, 
                                               @Mode   VARCHAR(100)
AS
    BEGIN
        SELECT *
        FROM tbl_MenuTabsUserControl UC
        WHERE UC.MenuID = @MenuID
              AND UC.TabID = @TabID
              AND UC.Mode = @Mode;
    END;
