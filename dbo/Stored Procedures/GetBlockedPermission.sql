CREATE PROC [dbo].[GetBlockedPermission](@UserRole VARCHAR(100))
AS
    BEGIN
        SELECT BlockedPermissionID, 
               ModuleName, 
               ObjectID, 
               UserRole, 
               Active, 
               CreateDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy, 
               dbo.F_GetObjectModuleName(ObjectID, 6) Deals, 
               dbo.F_GetObjectModuleName(ObjectID, 7) Portfolio, 
               dbo.F_GetObjectModuleName(ObjectID, 3) Funds, 
               dbo.F_GetObjectModuleName(ObjectID, 4) Contacts, 
               dbo.F_GetObjectModuleName(ObjectID, 5) Company
        FROM tbl_BlockedPermission
        WHERE UserRole = @UserRole;
    END;
