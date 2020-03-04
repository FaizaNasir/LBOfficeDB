CREATE PROCEDURE [dbo].[proc_ContactIndividual_GETOutlook]
(@email  VARCHAR(1000), 
 @isFull BIT
)
AS
    BEGIN
        SELECT DISTINCT 
               c.IndividualID, 
               c.IndividualEmail, 
               dbo.F_GetContactTypeNames(c.IndividualID) IndividualType, 
               c.IndividualDOB, 
               c.IndividualTitle, 
               c.IndividualFirstName, 
               c.IndividualMiddleName, 
               c.IndividualLastName, 
               c.IndividualComments, 
               c.IndividualAddress, 
               c.IndividualPhone, 
               c.IndividualMobile, 
               ind_con.CountryName IndividualCountryName, 
               ind_con.CountryPhoneCode IndividualCountryPhoneCode, 
               ind_city.CityName IndividualCityName, 
               ind_s.StateTitle IndividualStateName, 
               c.IndividualZipCode, 
               tcc.CompanyName, 
               CI.ContactPositionInCompany,
               CASE
                   WHEN ISNULL(CI.ContactEmailAddressInCompany, '') <> ''
                   THEN CI.ContactEmailAddressInCompany
                   ELSE c.IndividualEmail
               END EmailAddress, 
               CI.ContactEmailAddressInCompany, 
               CI.ContactDirectLineInCompany, 
               con.CountryPhoneCode CompanyCountryPhoneCode, 
               CI.ContactMobileNumberInCompany, 
               TCO.OfficePhone CompanyPhone, 
               CI.ContactDirectFaxInCompany, 
               tcc.CompanyWebSite, 
               tco.OfficeCity CompanyCityName, 
               TCO.OfficeAddress CompanyAddress, 
               TCO.OfficeFax CompanyFax, 
               TCO.OfficePOBox CompanyPOBox, 
               TCO.OfficeZip CompanyZip, 
               con.CountryName CompanyCountryName, 
               s.StateTitle StateName
        FROM tbl_ContactIndividual C
             LEFT JOIN tbl_country ind_con ON ind_con.CountryID = c.IndividualCountryID
             LEFT JOIN tbl_city ind_city ON ind_city.CityID = c.IndividualCityID
             LEFT JOIN tbl_State ind_s ON ind_s.StateID = c.StateID
             LEFT JOIN tbl_CompanyIndividuals CI ON CI.ContactIndividualID = C.IndividualID
                                                    AND CI.isMainCompany = 1
             LEFT JOIN tbl_CompanyOffice TCO ON CI.OfficeID = TCO.OfficeID
             LEFT JOIN tbl_country con ON con.CountryID = tco.CountryID
             LEFT JOIN tbl_State s ON s.StateID = tco.StateID
             LEFT JOIN tbl_ContactIndividualContactTypes CT(NOLOCK) ON CT.ContactIndividualID = c.IndividualID
             LEFT JOIN tbl_CompanyContact tcc ON tcc.CompanyContactID = CI.CompanyContactID
        WHERE 1 = CASE
                      WHEN tcc.CompanyName IS NOT NULL
                           AND ISNULL(CI.ContactEmailAddressInCompany, '') <> ''
                      THEN 1
                      WHEN ISNULL(c.IndividualEmail, '') <> ''
                      THEN 1
                      ELSE 0
                  END
              AND 1 = CASE
                          WHEN @isFull = 1
                          THEN 1
                          WHEN(c.CreatedDate >= ISNULL(
        (
            SELECT TOP 1 UpdateDate
            FROM tbl_outlookcontactsync o
            WHERE o.email = @email
        ), '01/01/1900')
                               OR c.UpdatedDate >= ISNULL(
        (
            SELECT TOP 1 UpdateDate
            FROM tbl_outlookcontactsync o
            WHERE o.email = @email
        ), '01/01/1900'))
                          THEN 1
                          ELSE 0
                      END;
    END;
