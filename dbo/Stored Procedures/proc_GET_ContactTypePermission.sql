CREATE PROCEDURE [dbo].[proc_GET_ContactTypePermission] @RoleID   NVARCHAR(256) = NULL, 
                                                        @ModuleID INT           = NULL
AS
    BEGIN
        SELECT tbl_ContactTypePermission.*, 
               tbl_ContactType.ContactTypeName
        FROM tbl_ContactTypePermission
             INNER JOIN tbl_ContactType ON tbl_ContactTypePermission.ContactTypesID = tbl_ContactType.ContactTypesID
        WHERE RoleID = ISNULL(@RoleID, RoleID)
              AND ModuleID = ISNULL(@ModuleID, ModuleID);
    END;
