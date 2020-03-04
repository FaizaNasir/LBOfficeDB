CREATE PROCEDURE [dbo].[proc_SET_ModuleObjectPermissions] @PermissionID           INT           = NULL, 
                                                          @ModuleID               INT           = NULL, 
                                                          @ModuleName             VARCHAR(100)  = NULL, 
                                                          @RoleID                 NVARCHAR(256) = NULL, 
                                                          @ModuleObjectID         INT           = NULL, 
                                                          @canView                BIT           = NULL, 
                                                          @canEdit                BIT           = NULL, 
                                                          @RestrictLinkedContacts BIT           = NULL, 
                                                          @NoAccess               BIT           = NULL
AS
    BEGIN
        IF(@PermissionID IS NULL)
            BEGIN
                INSERT INTO tbl_ModuleObjectPermissions
                ([ModuleID], 
                 [ModuleName], 
                 [RoleID], 
                 [ModuleObjectID], 
                 [canView], 
                 [canEdit], 
                 [RestrictLinkedContacts], 
                 NoAccess
                )
                VALUES
                (@ModuleID, 
                 @ModuleName, 
                 @RoleID, 
                 @ModuleObjectID, 
                 @canView, 
                 @canEdit, 
                 @RestrictLinkedContacts, 
                 @NoAccess
                );
        END;
        SET @PermissionID = @@IDENTITY;
        SELECT 'Success' AS Result, 
               @PermissionID AS 'PermissionID';
    END;  
