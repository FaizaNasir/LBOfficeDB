CREATE PROCEDURE [dbo].[proc_CompanyQuickSearch_GET] @RoleID    VARCHAR(MAX), 
                                                     @Character VARCHAR(10)   = NULL, 
                                                     @Type      VARCHAR(1000) = NULL
AS
     IF @Character IS NULL
         SET @Character = '%';
         ELSE
         SET @Character = @Character + '%';
     SELECT DISTINCT 
            c.CompanyContactID, 
            c.CompanyLogo, 
            c.ExternalAdvisorTypeID, 
            c.CompanyStatus, 
            c.CompanyIndustryID, 
            c.CompanyBusinessAreaID, 
            c.CompanyBusinessDesc, 
            c.CompanyName, 
            c.CompanyWebSite, 
            c.CompanyCreationDate, 
            c.CompanyCreatedDate, 
            c.CompanyStartCollaborationDate, 
            c.CompanyActivity, 
            c.CompanyLinkedIn, 
            c.CompanyFacebook, 
            c.CompanyTwitter, 
            c.CompanyComments, 
            office.OfficeCity, 
            office.CityID CompanyCityID, 
            office.CountryID CompanyCountryID, 
            office.StateID StateId, 
            office.OfficeAddress CompanyAddress, 
            office.OfficeZip CompanyZip, 
            office.OfficePOBox CompanyPOBox, 
            office.OfficePhone CompanyPhone, 
            office.OfficeFax CompanyFax, 
            office.OfficeID, 
     (
         SELECT CountryName
         FROM tbl_Country ccc
         WHERE ccc.countryID = office.CountryID
     ) CountryName, 
     (
         SELECT StateTitle
         FROM tbl_state s
         WHERE s.stateid = office.StateId
     ) StateTitle, 
            REPLACE(dbo.F_GetCompanyTypeNames(C.CompanyContactID), ',', ',') AS CompanyType, 
            b.IndividualFullName CompanyMainContact, 
            b.IndividualID CompanyMainIndividualID, 
            b.ContactPositionInCompany CompanyMainContactPosition, 
            b.ContactEmailAddressInCompany CompanyMainContactBusinessEmail, 
     (
         SELECT CountryPhoneCode
         FROM tbl_Country
         WHERE CountryID = office.CountryID
     ) AS CountryCode, 
            canEdit
     FROM tbl_CompanyContact C
          OUTER APPLY
     (
         SELECT TOP (1) *
         FROM tbl_CompanyOffice b
         WHERE b.CompanyContactID = c.CompanyContactID
               AND b.Ismain = 1
     ) AS office
          LEFT JOIN tbl_CompanyContactType CT ON C.CompanyContactID = CT.CompanyContactID
          LEFT JOIN tbl_ModuleObjectPermissions AS P ON C.CompanyContactID = P.ModuleObjectID
                                                        AND P.ModuleID = 5
                                                        AND P.RoleID = @RoleID
          OUTER APPLY
     (
         SELECT TOP 1 indiv.IndividualFullName, 
                      indiv.IndividualID, 
                      ci.ContactPositionInCompany, 
                      ci.ContactEmailAddressInCompany
         FROM tbl_CompanyIndividuals ci
              JOIN tbl_ContactIndividual indiv ON indiv.IndividualID = ci.ContactIndividualID
         WHERE ci.CompanyContactID = c.CompanyContactID
               AND ci.isMainIndividual = 1
     ) AS b
     WHERE NOT EXISTS
     (
         SELECT TOP 1 1
         FROM tbl_ContactTypePermission ctp
         WHERE ctp.RoleID = @RoleID
               AND ctp.ModuleID = 5
               AND ctp.ContactTypesID = Ct.ContactTypeID
               AND ISNULL(ctp.CanView, 1) = 0
     )
           AND ISNULL(P.CanView, 1) = 1
           AND c.companyname LIKE @Character
           AND NOT EXISTS
     (
         SELECT TOP 1 1
         FROM tbl_BlockedPermission b
         WHERE b.moduleName = 'Company'
               AND UserRole = @RoleID
               AND b.ObjectID = c.CompanyContactID
     )
           AND NOT EXISTS
     (
         SELECT TOP 1 1
         FROM tbl_BlockedGroupPermission b
              JOIN tbl_CompanyContactType cct ON b.TypeID = cct.ContactTypeID
         WHERE b.moduleID = 5
               AND UserRole = @RoleID
               AND cct.CompanyContactID = c.CompanyContactID
     )
     ORDER BY CompanyName;
