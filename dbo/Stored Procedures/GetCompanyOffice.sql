CREATE PROC [dbo].[GetCompanyOffice]
(@cityName  VARCHAR(1000), 
 @companyID INT
)
AS
    BEGIN
        IF @cityName = '0'
            SET @cityName = '';
        SELECT OfficeID, 
               c.CompanyContactID, 
               REPLACE(dbo.F_GetCompanyTypeNames(C.CompanyContactID), ',', ',') AS CompanyType, 
               OfficeName, 
               OfficeAddress, 
               OfficeZip, 
               OfficePOBox, 
               OfficeCity, 
               c.CountryID, 
               CityID, 
               OfficePhone OfficePhone, 
               OfficeFax OfficeFax, 
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
        FROM tbl_companyoffice c
             JOIN tbl_companycontact con ON con.companycontactid = c.companycontactid
             JOIN tbl_country cc ON cc.countryid = c.CountryID
        WHERE c.CompanyContactID = @companyID
              AND ISNULL(OfficeCity, '') LIKE '%' + @cityName + '%';
    END;
