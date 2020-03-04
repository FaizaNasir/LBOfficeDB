CREATE PROC [dbo].[proc_TabsPermission_del](@TabsPermissionID INT)
AS
    BEGIN
        DELETE FROM tbl_TabsPermission
        WHERE TabsPermissionID = @TabsPermissionID;
        SELECT 1 Result;
    END;
