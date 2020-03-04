CREATE PROCEDURE [dbo].[proc_GET_CompanyContactOffices] @RoleID    INT = NULL, 
                                                        @CompanyID INT = NULL
AS
    BEGIN
        SELECT O.OfficeID, 
               O.CompanyContactID, 
               O.OfficeName, 
               O.OfficeAddress, 
               O.OfficeZip, 
               O.OfficePOBox, 
               O.OfficeCity, 
               O.CountryID, 
               O.CityID, 
               O.OfficePhone, 
               O.OfficeFax, 
               O.isHeadOffice, 
               O.OfficeWebsite, 
               O.OfficeNewGUID, 
               O.StateID
        FROM tbl_CompanyContact C
             INNER JOIN tbl_companyOffice O ON C.CompanyContactID = O.CompanyContactID
        WHERE C.CompanyContactID = @CompanyID;
    END;
