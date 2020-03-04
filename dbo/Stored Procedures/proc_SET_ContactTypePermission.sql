CREATE PROCEDURE [dbo].[proc_SET_ContactTypePermission] @ContactTypePermissionID INT           = NULL, 
                                                        @RoleID                  NVARCHAR(256) = NULL, 
                                                        @ContactTypesID          INT           = NULL, 
                                                        @canView                 BIT           = NULL, 
                                                        @canEdit                 BIT           = NULL, 
                                                        @ModuleID                INT           = NULL, 
                                                        @RestrictLinkedContacts  BIT           = NULL
AS
    BEGIN
        IF(@ContactTypePermissionID IS NULL)
            BEGIN
                INSERT INTO tbl_ContactTypePermission
                ([RoleID], 
                 [ContactTypesID], 
                 [canView], 
                 [canEdit], 
                 [ModuleID], 
                 [RestrictLinkedContacts]
                )
                VALUES
                (@RoleID, 
                 @ContactTypesID, 
                 @canView, 
                 @canEdit, 
                 @ModuleID, 
                 @RestrictLinkedContacts
                );
        END;
        SET @ContactTypePermissionID = @@IDENTITY;
        SELECT 'Success' AS Result, 
               @ContactTypePermissionID AS 'ContactTypePermissionID';
    END;
