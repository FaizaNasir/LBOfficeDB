CREATE PROCEDURE [dbo].[proc_contact_report_GET]
AS
    BEGIN
        SET NOCOUNT ON;
        CREATE TABLE #tblRM
        (IndividualID                  INT, 
         ManagementCompanyIndividualID INT, 
         RM                            VARCHAR(MAX)
        );
        INSERT INTO #tblRM
               SELECT CI.IndividualID, 
                      ManagementCompanyIndividualID, 
                      MC.IndividualFullName
               FROM tbl_ContactIndividual CI
                    JOIN tbl_ContactIndividualRM RM ON CI.IndividualID = RM.IndividualId
                    JOIN tbl_ContactIndividual MC ON MC.IndividualID = RM.ManagementCompanyIndividualID;
        SELECT IndividualID, 
               RM = STUFF(
        (
            SELECT ', ' + CAST(RM AS VARCHAR)
            FROM #tblRM b
            WHERE b.IndividualID = a.IndividualID FOR XML PATH('')
        ), 1, 2, '')
        INTO #RM
        FROM #tblRM a
        GROUP BY IndividualID;
        IF OBJECT_ID('tempdb..#tblRM') IS NOT NULL
            DROP TABLE #tblRM;
        SELECT DISTINCT--Cont.IndividualID,

               IndividualTitle AS [Title], 
               IndividualFirstName AS [First Name], 
               IndividualMiddleName AS [Middle Name], 
               IndividualLastName AS [Last name], 
               LanguageName AS [Language], 
               RM AS [RM List], 
               (CASE
                    WHEN isMainCompany = 1
                    THEN ComCon.CompanyName
                    ELSE ''
                END) AS [Main company name], 
               ContactPositionInCompany AS [Position], 
               ContactDepartmentInCompany AS [Department], 
               ContactDirectLineInCompany AS [Direct line], 
               ContactMobileNumberInCompany AS [Business Mobile], 
               ContactEmailAddressInCompany AS [Business Mail], 
               CompanyPhone AS [Main company phone], 
               CompanyFax AS [Main company fax], 
               CompanyWebSite AS [Main company website], 
               CompanyAddress AS [Main company address], 
               CompanyZip AS [Main company zip code], 
               IndCity.CityName AS [Main company city], 
               ComCnty.CountryName AS [Main company country], 
               IndCnty.CountryName AS [Contact country], 
               IndividualMobile AS [Contact personal mobile], 
               IndividualEmail AS [Contact personal email], 
               IndividualLinkedInID AS [Contact Linkedin], 
               IndividualTwitterID AS [Contact Twitter]
        FROM Tbl_ContactIndividual cont
             JOIN tbl_CompanyIndividuals ComInd ON cont.IndividualID = ComInd.ContactIndividualID
                                                   AND isMainCompany = 1
             LEFT JOIN Tbl_CompanyContact ComCon ON ComCon.CompanyContactID = ComInd.CompanyContactID
             LEFT JOIN tbl_Language lan ON CAST(lan.LanguageID AS VARCHAR) = cont.LanguageID
             LEFT JOIN tbl_Country ComCnty ON ComCnty.CountryID = ComCon.CompanyCountryID
             LEFT JOIN tbl_Country IndCnty ON IndCnty.CountryID = cont.IndividualCountryID
             LEFT JOIN tbl_City IndCity ON IndCity.CityID = Cont.IndividualCityID
                                           AND IndCity.CountryID = cont.IndividualCountryID
             LEFT JOIN #RM R ON R.IndividualID = cont.IndividualID;
        IF OBJECT_ID('tempdb..#RM') IS NOT NULL
            DROP TABLE #RM;
        SET NOCOUNT OFF;
    END;
