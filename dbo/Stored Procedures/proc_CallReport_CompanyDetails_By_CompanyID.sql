--[proc_Test_Meeting_By_Individual] null,null,null,731

CREATE PROCEDURE [dbo].[proc_CallReport_CompanyDetails_By_CompanyID](@lnkToCompany VARCHAR(1000) = NULL)
AS
     IF @lnkToCompany = ''
         SET @lnkToCompany = NULL;
    BEGIN
        SELECT DISTINCT 
               c.CompanyContactID, 
               c.CompanyName, 
               c.CompanyAddress, 
               c.CompanyPOBox, 
               c.CompanyPhone, 
               c.CompanyFax, 
        (
            SELECT CountryName
            FROM dbo.tbl_Country cc
            WHERE cc.CountryID = c.CompanyCountryID
        ) CountryName, 
        (
            SELECT CountryPhoneCode
            FROM dbo.tbl_Country cc
            WHERE cc.CountryID = c.CompanyCountryID
        ) CountryPhoneCode, 
               CityName
        FROM tbl_CompanyContact c
             LEFT OUTER JOIN tbl_City ON c.CompanyCityID = tbl_City.CityID
        WHERE c.CompanyContactID = @lnkToCompany
        ORDER BY c.CompanyName ASC;
    END;
