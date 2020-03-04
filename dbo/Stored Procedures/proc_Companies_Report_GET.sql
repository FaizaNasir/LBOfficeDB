CREATE PROCEDURE [dbo].[proc_Companies_Report_GET]
AS
    BEGIN
        SET NOCOUNT ON;
        CREATE TABLE #tblContactType
        (CompanyContactID INT, 
         ContactTypeName  VARCHAR(MAX)
        );
        INSERT INTO #tblContactType
               SELECT ComCon.CompanyContactID, 
                      ContactTypeName
               FROM tbl_CompanyContact ComCon
                    LEFT JOIN tbl_CompanyContactType CCT ON CCT.CompanyContactID = ComCon.CompanyContactID
                    LEFT JOIN tbl_ContactType CT ON CT.ContactTypesID = CCT.ContactTypeID;
        SELECT CompanyContactID, 
               ContactTypeName = STUFF(
        (
            SELECT ', ' + CAST(ContactTypeName AS VARCHAR)
            FROM #tblContactType b
            WHERE b.CompanyContactID = a.CompanyContactID FOR XML PATH('')
        ), 1, 2, '')
        INTO #tblContactTypeAll
        FROM #tblContactType a
        GROUP BY CompanyContactID;
        SELECT CompanyName AS [Company name], 
               ContactTypeName AS [Company type], 
               CompanyPhone AS [Company phone], 
               CompanyFax AS [Company fax], 
               CompanyWebSite AS [Company website], 
               CompanyAddress AS [Company address], 
               CompanyZip AS [Company zip code], 
               CityName AS [Company city], 
               CountryName AS [Company country]
        FROM tbl_CompanyContact ComCon
             LEFT JOIN tbl_Country ComCnty ON ComCnty.CountryID = ComCon.CompanyCountryID
             LEFT JOIN tbl_City ComCity ON ComCity.CountryID = ComCon.CompanyCountryID
                                           AND ComCity.CityID = ComCon.CompanyCityID
             LEFT JOIN #tblContactTypeAll CT ON CT.CompanyContactID = ComCon.CompanyContactID;
        IF OBJECT_ID('tempdb..#tblContactType') IS NOT NULL
            DROP TABLE #tblContactType;
        IF OBJECT_ID('tempdb..#tblContactTypeAll') IS NOT NULL
            DROP TABLE #tblContactTypeAll;
        SET NOCOUNT OFF;
    END;
