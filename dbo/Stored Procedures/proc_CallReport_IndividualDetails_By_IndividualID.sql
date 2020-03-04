--[proc_Test_IndividualDetails_By_IndividualID] 731

CREATE PROCEDURE [dbo].[proc_CallReport_IndividualDetails_By_IndividualID](@otherIndividualID INT = NULL)
AS
    BEGIN
        SELECT DISTINCT 
               I.IndividualTitle, 
               I.IndividualID, 
               I.IndividualFullName, 
               CI.CompanyContactID, 
               cc.CompanyAddress, 
               cc.CompanyPhone, 
               cc.CompanyFax, 
               CityName, 
               cc.CompanyPOBox, 
        (
            SELECT CountryPhoneCode
            FROM dbo.tbl_Country c
            WHERE c.CountryID = cc.CompanyCountryID
        ) CountryPhoneCode, 
        (
            SELECT CountryName
            FROM dbo.tbl_Country c
            WHERE c.CountryID = cc.CompanyCountryID
        ) CountryName
        FROM tbl_ContactIndividual AS I
             INNER JOIN tbl_CompanyIndividuals AS CI ON CI.ContactIndividualID = I.IndividualID
                                                        AND CI.isMainCompany = 1
             INNER JOIN tbl_CompanyContact AS CC ON CI.CompanyContactID = CC.CompanyContactID
             LEFT OUTER JOIN tbl_City ON CC.CompanyCityID = tbl_City.CityID
        WHERE I.IndividualID = @otherIndividualID
        ORDER BY IndividualFullName;
    END;
