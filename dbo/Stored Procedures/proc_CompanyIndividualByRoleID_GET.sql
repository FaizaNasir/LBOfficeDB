CREATE PROCEDURE [dbo].[proc_CompanyIndividualByRoleID_GET]   --'Back Office'    
@RoleID VARCHAR(100) = NULL
AS
    BEGIN
        SELECT DISTINCT 
               CI.[CompanyContactID], 
               CI.[ContactIndividualID]
        FROM tbl_ContactTypePermission CTP
             INNER JOIN tbl_CompanyContactType CCT ON CTP.ContactTypesID = CCT.ContactTypeID
             INNER JOIN tbl_CompanyIndividuals CI ON CCT.CompanyContactID = CI.CompanyContactID
        WHERE CTP.RoleID = ISNULL(@RoleID, CTP.RoleID)
              AND CTP.ModuleID = 5
              AND CI.TeamTypeName = 'Executive Team'
              AND CTP.RestrictLinkedContacts = 1
        UNION
        SELECT DISTINCT 
               CI.[CompanyContactID], 
               CI.[ContactIndividualID]
        FROM tbl_ModuleObjectPermissions MOP
             INNER JOIN tbl_CompanyIndividuals CI ON MOP.ModuleObjectID = CI.CompanyContactID
        WHERE MOP.RoleID = ISNULL(@RoleID, MOP.RoleID)
              AND MOP.ModuleID = 5
              AND CI.TeamTypeName = 'Executive Team'
              AND MOP.RestrictLinkedContacts = 1;
    END;
