CREATE PROC [dbo].[DeleteBlockedGroupPermission](@userRole VARCHAR(100))
AS
    BEGIN
        DELETE FROM tbl_BlockedGroupPermission
        WHERE UserRole = @userRole;
        SELECT 1 Result;
    END;
