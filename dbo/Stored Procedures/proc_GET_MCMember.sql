CREATE PROCEDURE [dbo].[proc_GET_MCMember] --'Fund','test'    
@ModuleName NVARCHAR(256) = NULL, 
@RoleName   NVARCHAR(256) = NULL
AS
    BEGIN
        IF(@ModuleName = 'ContactIndividual')
            BEGIN
                SELECT tbl_ModuleObjectPermissions.ModuleObjectID AS 'ID', 
                       tbl_ContactIndividual.IndividualFullName AS 'Name', 
                       canView, 
                       canEdit, 
                       NoAccess
                FROM tbl_ModuleObjectPermissions
                     INNER JOIN tbl_ContactIndividual ON tbl_ModuleObjectPermissions.ModuleObjectID = tbl_ContactIndividual.IndividualID
                WHERE tbl_ModuleObjectPermissions.ModuleName = ISNULL(@ModuleName, tbl_ModuleObjectPermissions.ModuleName)
                      AND tbl_ModuleObjectPermissions.RoleID = ISNULL(@RoleName, tbl_ModuleObjectPermissions.RoleID);
        END;
            ELSE
            BEGIN
                IF(@ModuleName = 'ContactCompany')
                    BEGIN
                        SELECT tbl_ModuleObjectPermissions.ModuleObjectID AS 'ID', 
                               tbl_CompanyContact.CompanyName AS 'Name', 
                               canView, 
                               canEdit, 
                               NoAccess
                        FROM tbl_ModuleObjectPermissions
                             INNER JOIN tbl_CompanyContact ON tbl_ModuleObjectPermissions.ModuleObjectID = tbl_CompanyContact.CompanyContactID
                        WHERE tbl_ModuleObjectPermissions.ModuleName = ISNULL(@ModuleName, tbl_ModuleObjectPermissions.ModuleName)
                              AND tbl_ModuleObjectPermissions.RoleID = ISNULL(@RoleName, tbl_ModuleObjectPermissions.RoleID);
                END;
                    ELSE
                    BEGIN
                        IF(@ModuleName = 'Deals')
                            BEGIN
                                SELECT tbl_ModuleObjectPermissions.ModuleObjectID AS 'ID', 
                                       tbl_Deals.DealName AS 'Name', 
                                       canView, 
                                       canEdit, 
                                       NoAccess
                                FROM tbl_ModuleObjectPermissions
                                     INNER JOIN tbl_Deals ON tbl_ModuleObjectPermissions.ModuleObjectID = tbl_Deals.DealID
                                WHERE tbl_ModuleObjectPermissions.ModuleName = ISNULL(@ModuleName, tbl_ModuleObjectPermissions.ModuleName)
                                      AND tbl_ModuleObjectPermissions.RoleID = ISNULL(@RoleName, tbl_ModuleObjectPermissions.RoleID);
                        END;
                            ELSE
                            BEGIN
                                SELECT tbl_ModuleObjectPermissions.ModuleObjectID AS 'ID', 
                                       ModuleName AS 'Name', 
                                       canView, 
                                       canEdit, 
                                       NoAccess
                                FROM tbl_ModuleObjectPermissions
                                WHERE tbl_ModuleObjectPermissions.ModuleName = ISNULL(@ModuleName, tbl_ModuleObjectPermissions.ModuleName)
                                      AND tbl_ModuleObjectPermissions.RoleID = ISNULL(@RoleName, tbl_ModuleObjectPermissions.RoleID);
                        END;
                END;
        END;
    END; 
