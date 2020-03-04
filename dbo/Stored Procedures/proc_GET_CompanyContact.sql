CREATE PROCEDURE [dbo].[proc_GET_CompanyContact] @RoleID    VARCHAR(MAX), 
                                                @CompanyID INT          = NULL
AS

    --SET @RoleID = NULL;

    BEGIN
        SELECT C.CompanyContactID, 
               C.ExternalAdvisorTypeID, 
               C.CompanyLogo, 
               co.CountryID CompanyCountryID, 
               co.CityID CompanyCityID, 
               C.CompanyMainIndividualID, 
               C.CompanyStatus, 
               C.CompanyIndustryID, 
               C.CompanyBusinessAreaID, 
               C.CompanyBusinessDesc, 
               C.CompanyName, 
               C.CompanyWebSite, 
               C.LPTypeID, 
               C.AccountName, 
               co.OfficeAddress CompanyAddress, 
               co.OfficeZip CompanyZip, 
               co.OfficePOBox CompanyPOBox, 
               co.OfficePhone CompanyPhone, 
               co.OfficeFax CompanyFax, 
               C.CompanyCreationDate, 
               C.CompanyCreatedDate, 
               C.CompanyStartCollaborationDate, 
               C.CompanyActivity, 
               C.CompanyLinkedIn, 
               C.CompanyFacebook, 
               C.CompanyTwitter, 
               C.CompanyComments, 
               P.ModuleID, 
               P.ModuleName, 
               P.ModuleObjectID, 
               P.canView, 
               P.canEdit, 
               P.PermissionID, 
               P.RoleID, 
               C.StateId ManagementCompanyID, 
               co.StateId, 
               co.OfficeCity, 
               co.OfficeID
        FROM dbo.tbl_CompanyContact AS C
             LEFT JOIN tbl_companyoffice co ON co.CompanyContactID = c.CompanyContactID
                                               AND co.ismain = 1
             LEFT JOIN tbl_ModuleObjectPermissions AS P ON C.CompanyContactID = P.ModuleObjectID
                                                           AND p.ModuleID = 5
                                                           AND p.RoleID = ISNULL(@RoleID, p.RoleID) -- AND P.ModuleName = 'CompanyContact' AND P.RoleID = @RoleID --AND P.CanView=1   

             LEFT JOIN tbl_CompanyContactType CT(NOLOCK) ON CT.CompanyContactID = C.CompanyContactID
             LEFT JOIN tbl_ContactTypePermission ctp ON ctp.ContactTypesID = CT.ContactTypeID
                                                        AND ctp.RoleID = ISNULL(@RoleID, ctp.RoleID)
                                                        AND ctp.ModuleID = 5
        WHERE C.CompanyContactID = ISNULL(@CompanyID, C.CompanyContactID)
              AND C.CompanyContactID NOT IN
        (
            SELECT b.ObjectID
            FROM tbl_BlockedPermission b
            WHERE b.moduleName = 'Company'
                  AND UserRole = @RoleID
        )
              AND C.CompanyContactID NOT IN
        (
            SELECT cct.CompanyContactID
            FROM tbl_BlockedGroupPermission b
                 JOIN tbl_CompanyContactType cct ON b.TypeID = cct.ContactTypeID
            WHERE b.moduleID = 5
                  AND UserRole = @RoleID
                  AND cct.CompanyContactID = cct.CompanyContactID
        )
        ORDER BY c.CompanyName;
    END;
