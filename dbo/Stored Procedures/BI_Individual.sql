CREATE PROC [dbo].[BI_Individual]
AS
    BEGIN
        SELECT '----General----' '----General----', 
               i.IndividualID ID, 
               ISNULL(i.IndividualTitle, '') Title, 
               ISNULL(i.IndividualLastName, '') 'Last name', 
               ISNULL(i.IndividualMiddleName, '') 'Middle name', 
               ISNULL(i.IndividualFirstName, '') 'First name', 
               ISNULL(i.IndividualDOB, '') 'Date of birth', 
               ISNULL(dbo.[F_GetContactTypeNames](i.IndividualID), '') Type, 
               ISNULL(i.LanguageID, '') Language, 
               ISNULL(i.IndividualComments, '') Notes, 
               ISNULL(i.IndividualEmail, '') 'Personal email', 
               ISNULL(coun.countryphonecode + ' ' + i.IndividualMobile, '') 'Personal mobile', 
               ISNULL(coun.countryphonecode + ' ' + i.IndividualPhone, '') 'Personal phone', 
               ISNULL(i.IndividualAddress, '') 'Personal address', 
               ISNULL(i.IndividualZipCode, '') 'Personal zip code', 
               ISNULL(
        (
            SELECT cityname
            FROM tbl_city c
            WHERE c.cityid = i.IndividualCityID
        ), '') City, 
        (
            SELECT 'State title'
            FROM tbl_State s
            WHERE s.StateID = i.stateid
        ) 'Personal state', 
               ISNULL(
        (
            SELECT countryname
            FROM tbl_country c
            WHERE c.countryiD = i.IndividualCountryID
        ), '') Country, 
               ISNULL(
        (
            SELECT ISO
            FROM tbl_country c
            WHERE c.countryiD = i.IndividualCountryID
        ), '') CountryISO, 
               ISNULL(
        (
            SELECT ISO2
            FROM tbl_country c
            WHERE c.countryiD = i.IndividualCountryID
        ), '') CountryISO2, 
               ISNULL(
        (
            SELECT countryname
            FROM tbl_country c
            WHERE c.countryiD = n.CountryID
        ), '') Nationality, 
               ISNULL(
        (
            SELECT ISO
            FROM tbl_country c
            WHERE c.countryiD = n.CountryID
        ), '') NationalityISO, 
               ISNULL(
        (
            SELECT ISO2
            FROM tbl_country c
            WHERE c.countryiD = n.CountryID
        ), '') NationalityISO2, 
               ISNULL(i.IndividualLinkedInID, '') Linkedin, 
               ISNULL(i.IndividualSkypeID, '') Skype, 
               '----Company----' '----Company----', 
               c.CompanyContactID CompanyID, 
               ISNULL(c.CompanyName, '') Company,
               CASE
                   WHEN ci.isMainCompany = 1
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is main company',
               CASE
                   WHEN ci.isMainIndividual = 1
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is main contact', 
               ISNULL(co.OfficeAddress, '') 'Business address', 
        (
            SELECT StateTitle
            FROM tbl_State s
            WHERE s.StateID = co.stateid
        ) 'Business state', 
               ISNULL(co.OfficeCity, '') 'Business city', 
               ISNULL(co.OfficeZip, '') 'Business zip code', 
               ISNULL(
        (
            SELECT countryname
            FROM tbl_country c
            WHERE c.countryid = co.CountryID
        ), '') 'Business country', 
               ISNULL(ISNULL(bcoun.countryphonecode, '') + ' ' + co.OfficePhone, '') 'Business phone', 
               ISNULL(ISNULL(bcoun.countryphonecode, '') + ' ' + co.OfficeFax, '') 'Business fax', 
               ISNULL(ci.ContactDirectLineInCompany, '') 'Direct phone', 
               ISNULL(ISNULL(bcoun.countryphonecode, '') + ' ' + ci.ContactMobileNumberInCompany, '') BusinessMobile, 
               ISNULL(ci.ContactEmailAddressInCompany, '') 'Business email',
               CASE
                   WHEN ci.TeamTypeName = 'Adivsory Board'
                   THEN 'Advisory Board'
                   ELSE ci.TeamTypeName
               END 'Team type', 
               ISNULL(CASE
                          WHEN ci.TeamTypeName = 'Adivsory Board'
                          THEN ci.ContactRole
                          ELSE ci.ContactPositionInCompany
                      END, '') Position, 
               ISNULL(ci.ContactDepartmentInCompany, '') Department, 
               ci.ContactDateOfJoiningInCompany 'Joined on', 
               ci.ContactDateOfLeavingFromCompany 'Left on', 
               '----Personal assistant----' '----Personal assistant----', 
               ISNULL(pa.IndividualTitle, '') 'PA Title', 
               ISNULL(pa.IndividualLastName, '') 'PA Last name', 
               ISNULL(pa.IndividualFirstName, '') 'PA First name', 
               ISNULL(ISNULL(bcoun.countryphonecode, '') + ' ' + paci.ContactDirectLineInCompany, '') 'PA Direct phone', 
               ISNULL(ISNULL(bcoun.countryphonecode, '') + ' ' + paci.ContactMobileNumberInCompany, '') 'PA Business mobile', 
               ISNULL(paci.ContactEmailAddressInCompany, '') 'PA Email'
        FROM tbl_contactindividual i
             LEFT JOIN tbl_Nationality n ON n.IndividualID = i.IndividualID
             LEFT JOIN tbl_country coun ON coun.countryid = i.IndividualCountryID
             LEFT JOIN tbl_companyindividuals ci ON i.individualid = ci.contactindividualid
             LEFT JOIN tbl_companycontact c ON c.companycontactid = ci.companycontactid
             LEFT JOIN tbl_companyoffice co ON co.officeID = ci.officeID
             LEFT JOIN tbl_country Bcoun ON Bcoun.countryid = co.countryID
             LEFT JOIN tbl_companyindividuals paci ON ci.ContactPrivateAssitantID = paci.contactindividualid
                                                      AND paci.TeamTypeName = 'Executive Team'
                                                      AND paci.ContactPositionInCompany = 'Personal Assistant'
             LEFT JOIN tbl_ContactIndividual pa ON pa.individualid = paci.ContactIndividualID;
    END;
