CREATE PROCEDURE [dbo].[proc_DEL_Individualuser] @UserName NVARCHAR(256) = NULL
AS
    BEGIN
        DELETE FROM tbl_Individualuser
        WHERE UserName = @UserName;
    END;
        SELECT 1;
