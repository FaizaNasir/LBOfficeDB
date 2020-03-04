CREATE PROC [dbo].[GetCompanyIndividualOffice]
(@individualID INT, 
 @companyID    INT
)
AS
    BEGIN
        SELECT ci.OfficeID, 
               c.CompanyContactID, 
               REPLACE(dbo.F_GetCompanyTypeNames(C.CompanyContactID), ',', ',') AS CompanyType, 
               OfficeName, 
               OfficeAddress + ' , ' + CAST(ISNULL(OfficeZip, '') AS VARCHAR(100)) + ', ' + OfficeCity + ' , ' + ISNULL(
        (
            SELECT StateTitle
            FROM tbl_state s
            WHERE s.stateid = c.stateid
        ), '') + ',' + CountryName OfficeAddress, 
               OfficeZip, 
               OfficePOBox, 
               OfficeCity, 
               c.CountryID, 
               CityID, 
               CountryPhoneCode + OfficePhone OfficePhone, 
               CountryPhoneCode + OfficeFax OfficeFax, 
               isHeadOffice, 
               CompanyWebSite OfficeWebsite, 
               OfficeNewGUID, 
        (
            SELECT StateTitle
            FROM tbl_state s
            WHERE s.stateid = c.stateid
        ) StateName, 
               c.StateID, 
               IsMain, 
               CountryPhoneCode, 
               CountryName
        FROM tbl_companyindividuals ci
             JOIN tbl_companyoffice c ON c.officeID = ci.OfficeID
             JOIN tbl_companycontact con ON con.companycontactid = c.companycontactid
             JOIN tbl_country cc ON cc.countryid = c.CountryID
        WHERE ci.CompanyContactID = @companyID
              AND ci.ContactIndividualID = @individualID;
    END;
