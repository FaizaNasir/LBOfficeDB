CREATE PROC [dbo].[GetContacts_ExcelPlugin]
AS
    BEGIN
        SELECT DISTINCT 
               i.IndividualID, 
               i.IndividualTitle, 
               i.IndividualFirstName, 
               i.IndividualLastName, 
               dbo.F_GetContactTypeNames(i.IndividualID) ContactType, 
               i.LanguageID, 
               i.IndividualComments IndividualNotes, 
               dbo.[F_GetContactRM](i.IndividualID) Team_knowledge, 
               i.IndividualLinkedInID LinkedIn, 
               i.IndividualEmail PersonalEmail, 
               i.IndividualMobile PersonalMobile, 
               i.IndividualPhone PersonalPhone, 
        (
            SELECT countryname
            FROM tbl_country con
            WHERE con.countryid = i.IndividualCountryID
        ) PersonalCountry, 
        (
            SELECT CityName
            FROM tbl_city cty
            WHERE cty.CityID = i.IndividualCityID
        ) PersonalCity, 
        (
            SELECT StateTitle
            FROM tbl_State s
            WHERE s.StateID = i.StateId
        ) PersonalState, 
               i.IndividualAddress PersonalAddress, 
               i.IndividualZipCode PersonalZipCode, 
               i.IndividualSkypeID Skype, 
               cc.CompanyWebSite WebSite, 
               cc.CompanyName, 
               dbo.[F_GetCompanyTypeNames](cc.CompanyContactID) CompanyType, 
               ci.ContactPositionInCompany Position, 
               ci.ContactDirectLineInCompany DirectPhone, 
               ci.ContactMobileNumberInCompany CompanyMobile, 
               ci.ContactEmailAddressInCompany CompanyEmail, 
               co.OfficeAddress, 
        (
            SELECT countryname
            FROM tbl_country con
            WHERE con.countryid = co.CountryID
        ) CompanyCountry, 
               co.OfficeCity CompanyCity, 
        (
            SELECT StateTitle
            FROM tbl_State s
            WHERE s.StateID = co.StateID
        ) CompanyState, 
               co.OfficePhone, 
               co.OfficeZip, 
               co.OfficeFax, 
               cc.CompanyComments CompanyNotes, 
               pa.IndividualTitle PaTitle, 
               pa.IndividualFirstName PaFirstName, 
               pa.IndividualLastName PaLastName, 
               pac.ContactEmailAddressInCompany PaEmail, 
               pac.ContactDirectLineInCompany PaDirectPhone, 
               ba.BusinessAreaTitle Sector, 
               ind.CompanyIndustryTitle Industry
        FROM tbl_ContactIndividual i
             LEFT JOIN tbl_CompanyIndividuals ci ON i.IndividualID = ci.ContactIndividualID
                                                    AND ci.isMainCompany = 1
                                                    AND ci.TeamTypeName = 'Executive Team'
             LEFT JOIN tbl_CompanyContact cc ON cc.companycontactid = ci.CompanyContactID
             LEFT JOIN tbl_CompanyOffice co ON co.CompanyContactID = cc.CompanyContactID
                                               AND ci.OfficeID = co.OfficeID
             LEFT JOIN tbl_BusinessArea ba ON ba.BusinessAreaID = cc.CompanyBusinessAreaID
             LEFT JOIN tbl_CompanyIndustries ind ON ind.CompanyIndustryID = cc.CompanyIndustryID
             LEFT JOIN tbl_contactindividual pa ON pa.individualid = ci.ContactPrivateAssitantID
             LEFT JOIN tbl_companyindividuals pac ON pac.ContactIndividualID = pa.individualid
                                                     AND pac.ContactPositionInCompany = 'Personal Assistant'
        ORDER BY i.IndividualLastName, 
                 i.IndividualFirstName;
    END;
