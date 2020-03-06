CREATE PROC [dbo].[BI_Company]
AS
    BEGIN
        SELECT DISTINCT 
               '----General123----' '----General----', 
               cc.CompanyContactID ID, 
               ISNULL(cc.CompanyName, '') 'Company name', 
               ISNULL(dbo.[F_GetCompanyTypeNames](cc.companycontactid), '') 'Company type',
               CASE
                   WHEN LEN(ISNULL(cc.CompanyLogo, '')) = 0
                   THEN ''
                   ELSE 'http://gvepeps.officectbr.ch/LBOPicturelib/' + cc.CompanyLogo
               END 'Company logo', 
               ISNULL(cc.CompanyWebSite, '') Website, 
               ISNULL(cc.CompanyComments, '') Notes, 
               ISNULL(
        (
            SELECT CompanyIndustryTitle
            FROM tbl_CompanyIndustries ci
            WHERE ci.CompanyIndustryID = cc.CompanyIndustryID
        ), '') Industry, 
               ISNULL(
        (
            SELECT BusinessAreaTitle
            FROM tbl_BusinessArea ba
            WHERE ba.BusinessAreaID = cc.CompanyBusinessAreaID
        ), '') Sector, 
               ISNULL(cc.CompanyBusinessDesc, '') 'Business profile', 
               cc.CompanyStartCollaborationDate 'Start collaboration on', 
               cc.CompanyCreationDate 'Creation date', 
               '----Office----' '----Office----', 
               ISNULL(co.OfficeAddress, '') Address, 
               ISNULL(co.OfficeZip, '') 'Zip code', 
               ISNULL(co.OfficeCity, '') City, 
               ISNULL(
        (
            SELECT StateTitle
            FROM tbl_state s
            WHERE s.StateID = co.StateID
        ), '') State, 
               ISNULL(
        (
            SELECT countryname
            FROM tbl_country c
            WHERE c.countryid = co.CountryID
        ), '') Country, 
               ISNULL(
        (
            SELECT ISO
            FROM tbl_country c
            WHERE c.countryid = co.CountryID
        ), '') CountryISO, 
               ISNULL(
        (
            SELECT ISO2
            FROM tbl_country c
            WHERE c.countryid = co.CountryID
        ), '') CountryISO2,
               CASE
                   WHEN co.Ismain = 1
                   THEN 'Yes'
                   ELSE ''
               END 'Is main', 
               ISNULL(
        (
            SELECT countryphonecode
            FROM tbl_country c
            WHERE c.countryid = co.countryid
        ) + ' ' + co.OfficePhone, '') Phone, 
               ISNULL(
        (
            SELECT countryphonecode
            FROM tbl_country c
            WHERE c.countryid = co.countryid
        ) + ' ' + co.OfficeFax, '') Fax, 
               '----Contacts----' '----Contacts----', 
               ISNULL(i.IndividualTitle, '') Title, 
               ISNULL(i.IndividualFirstName, '') 'First name', 
               ISNULL(i.IndividualLastName, '') 'Last name', 
               ISNULL(
        (
            SELECT OfficeCity
            FROM tbl_companyoffice ico
            WHERE ico.officeid = ci.OfficeID
        ), '') 'Office city',
               CASE
                   WHEN TeamTypeName = 'Adivsory Board'
                   THEN 'Advisory Board'
                   ELSE TeamTypeName
               END 'TeamType', 
               ISNULL(CASE
                          WHEN TeamTypeName = 'Adivsory Board'
                          THEN ci.ContactRole
                          ELSE ci.ContactPositionInCompany
                      END, '') Position, 
               ISNULL(ci.ContactDepartmentInCompany, '') Department, 
               ci.ContactDateOfJoiningInCompany 'Join on', 
               ci.ContactDateOfLeavingFromCompany 'Left on',
               CASE
                   WHEN ci.isMainCompany = 1
                   THEN 'Yes'
                   ELSE ''
               END 'Is main company',
               CASE
                   WHEN ci.IsMainIndividual = 1
                        AND TeamTypeName = 'Executive Team'
                   THEN 'Yes'
                   ELSE ''
               END 'Is main individual'
        FROM tbl_companycontact cc
             LEFT JOIN tbl_CompanyOffice co ON co.CompanyContactID = cc.companycontactid
             LEFT JOIN tbl_CompanyIndividuals ci ON cc.companycontactid = ci.CompanyContactID
             LEFT JOIN tbl_ContactIndividual i ON i.individualid = ci.ContactIndividualID;
    END;
