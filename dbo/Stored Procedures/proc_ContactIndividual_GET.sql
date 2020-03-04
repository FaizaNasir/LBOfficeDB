CREATE PROCEDURE [dbo].[proc_ContactIndividual_GET] @RoleID              VARCHAR(MAX) = NULL, 
                                                    @ContactIndividualID INT          = NULL
AS
    BEGIN
        SELECT DISTINCT 
               c.*, 
               CI.*, 
               PA.IndividualFirstName AS PAFirstName, 
               PA.IndividualLastName AS PALastName, 
               PACI.ContactEmailAddressInCompany AS PAEmail, 
               PACI.ContactMobileNumberInCompany AS PAMObile, 
               PACI.ContactDirectFaxInCompany AS PAfax, 
               PACI.ContactDirectLineInCompany AS PADirectLine, 
               PA.IndividualMiddleName AS PAMiddleName, 
               PACI.ContactFaxNumberInCompany AS PAZipCode, 
               P.*, 
               tcc.CompanyName, 
               tcc.CompanyAddress, 
               tcc.CompanyFax, 
               tcc.CompanyPOBox, 
               tcc.CompanyPhone, 
               tcc.CompanyWebSite, 
               tcc.CompanyZip, 
        (
            SELECT ISNULL(tbcn.CountryName, '')
            FROM tbl_Country tbcn
            WHERE tbcn.CountryID = tcc.CompanyCountryID
        ) AS CompanyCountryName, 
        (
            SELECT ISNULL(tbcn.CountryPhoneCode, '')
            FROM tbl_Country tbcn
            WHERE tbcn.CountryID = tcc.CompanyCountryID
        ) AS CompanyCountryPhoneCode, 
        (
            SELECT ISNULL(tbcity.CityName, '')
            FROM tbl_City tbcity
            WHERE tbcity.CityID = tcc.CompanyCityID
                  AND tbcity.CountryID = tcc.CompanyCountryID
        ) AS CompanyCityName, 
        (
            SELECT ISNULL(tbst.StateTitle, '')
            FROM tbl_State tbst
            WHERE tbst.StateID = C.StateId
        ) AS StateName, 
        (
            SELECT ISNULL(tbcn.CountryPhoneCode, '')
            FROM tbl_Country tbcn
            WHERE tbcn.CountryID = TCO.CountryID
        ) AS OfficeCountryPhoneCode, 
               TCO.OfficeAddress AS OfficeAddress, 
               TCO.OfficeFax, 
               TCO.OfficePOBox, 
               TCO.OfficePhone, 
               TCO.OfficeWebSite, 
               TCO.OfficeZip, 
        (
            SELECT ISNULL(tbcn.CountryName, '')
            FROM tbl_Country tbcn
            WHERE tbcn.CountryID = TCO.CountryID
        ) AS OfficeCountryName, 
        (
            SELECT ISNULL(tbcity.CityName, '')
            FROM tbl_City tbcity
            WHERE tbcity.CityID = TCO.CityID
                  AND tbcity.CountryID = TCO.CountryID
        ) AS OfficeCityName, 
        (
            SELECT ISNULL(tbst.StateTitle, '')
            FROM tbl_State tbst
            WHERE tbst.StateID = TCO.StateID
        ) AS OfficeStateName, 
        (
            SELECT ISNULL(tbcn.CountryPhoneCode, '')
            FROM tbl_Country tbcn
            WHERE tbcn.CountryID = C.IndividualCountryID
        ) AS IndividualCountryPhoneCode, 
        (
            SELECT ISNULL(tbcn.CountryName, '')
            FROM tbl_Country tbcn
            WHERE tbcn.CountryID = C.IndividualCountryID
        ) AS IndividualCountryName, 
        (
            SELECT ISNULL(tbcity.CityName, '')
            FROM tbl_City tbcity
            WHERE tbcity.CityID = C.IndividualCityID
                  AND tbcity.CountryID = C.IndividualCountryID
        ) AS IndividualCityName, 
        (
            SELECT ISNULL(tbst.StateTitle, '')
            FROM tbl_State tbst
            WHERE tbst.StateID = C.StateID
        ) AS IndividualStateName, 
               dbo.[F_ContactNationality](c.individualid) AS NationalityName
        FROM tbl_ContactIndividual C
             LEFT JOIN tbl_CompanyIndividuals CI ON CI.ContactIndividualID = C.IndividualID
                                                    AND CI.isMainCompany = 1
             LEFT JOIN tbl_CompanyOffice TCO ON CI.OfficeID = TCO.OfficeID
             LEFT JOIN tbl_CoNTACTIndividual PA ON PA.IndividualID = CI.ContactPrivateAssitantID
             LEFT JOIN tbl_CompanyIndividuals PACI ON PA.IndividualID = PACI.ContactIndividualID
                                                      AND PACI.isMainCompany = 1
             LEFT JOIN tbl_ModuleObjectPermissions AS P ON C.IndividualID = P.ModuleObjectID
                                                           AND P.ModuleID = 4
                                                           AND P.RoleID = ISNULL(@RoleID, p.RoleID)
             LEFT JOIN tbl_ContactIndividualContactTypes CT(NOLOCK) ON CT.ContactIndividualID = c.IndividualID
             LEFT JOIN tbl_ContactTypePermission ctp ON ctp.ContactTypesID = CT.ContactIndividualTypeID
                                                        AND ctp.RoleID = ISNULL(@RoleID, ctp.RoleID)
                                                        AND ctp.ModuleID = 4
                                                        AND c.active = 1
             LEFT JOIN tbl_CompanyContact tcc ON tcc.CompanyContactID = CI.CompanyContactID
        WHERE C.IndividualID = ISNULL(@ContactIndividualID, C.IndividualID)
              AND C.IndividualID NOT IN
        (
            SELECT b.ObjectID
            FROM tbl_BlockedPermission b
            WHERE b.moduleName = 'Contacts'
                  AND UserRole = @RoleID
        )
              AND C.IndividualID NOT IN
        (
            SELECT cct.ContactIndividualID
            FROM tbl_BlockedGroupPermission b
                 JOIN tbl_ContactIndividualContactTypes cct ON b.TypeID = cct.ContactIndividualTypeID
            WHERE UserRole = 'LbofficeAdmin'
                  AND cct.ContactIndividualID = C.IndividualID
                  AND b.moduleID = 4
        );
    END;
