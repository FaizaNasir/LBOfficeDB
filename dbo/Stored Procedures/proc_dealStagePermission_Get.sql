CREATE PROC [dbo].[proc_dealStagePermission_Get](@roleName VARCHAR(100))
AS
    BEGIN
        SELECT DealStageID
        FROM tbl_DealStagePermission
        WHERE rolename = @roleName;
    END;
