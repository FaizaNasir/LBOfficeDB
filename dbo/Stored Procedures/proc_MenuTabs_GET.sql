CREATE PROCEDURE [dbo].[proc_MenuTabs_GET] @RoleID         INT          = 0, 
                                           @MenuID         INT          = NULL, 
                                           @ModuleName     VARCHAR(100) = NULL, 
                                           @ModuleObjectID INT          = NULL
AS
    BEGIN
        DECLARE @canEdit BIT= 1, @canView BIT= 1;
        IF EXISTS
        (
            SELECT *
            FROM tbl_ModuleObjectPermissions
            WHERE ModuleName = @ModuleName
                  AND ModuleObjectID = @ModuleObjectID
                  AND @RoleID = ISNULL(@RoleID, 0)
        )
            BEGIN
                IF EXISTS
                (
                    SELECT *
                    FROM tbl_ModuleObjectPermissions
                    WHERE ModuleName = @ModuleName
                          AND ModuleObjectID = @ModuleObjectID
                          AND @RoleID = ISNULL(@RoleID, 0)
                          AND ISNULL(canView, 1) = 0
                )
                    BEGIN
                        SET @canView = 0;
                END;
                IF EXISTS
                (
                    SELECT *
                    FROM tbl_ModuleObjectPermissions
                    WHERE ModuleName = @ModuleName
                          AND ModuleObjectID = @ModuleObjectID
                          AND @RoleID = ISNULL(@RoleID, 0)
                          AND ISNULL(canEdit, 1) = 0
                )
                    BEGIN
                        SET @canEdit = 0;
                END;
        END;

        --select * from tbl_MenuTabs
        SELECT *,
               CASE
                   WHEN isEditable = 1
                   THEN @canEdit
                   ELSE 0
               END AS CanEdit
        FROM tbl_MenuTabs
        WHERE MENUID = ISNULL(@MenuID, MenuID);
    END;
