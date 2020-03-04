CREATE PROC [dbo].[proc_companycontact_ExcelImport]
(@companyName   VARCHAR(100), 
 @headoffice    VARCHAR(100), 
 @zipCode       VARCHAR(100), 
 @city          INT, 
 @country       INT, 
 @pho           VARCHAR(100), 
 @fax           VARCHAR(100), 
 @website       VARCHAR(100), 
 @companyType   VARCHAR(100), 
 @sector        INT, 
 @industry      INT, 
 @businessDescp VARCHAR(5000), 
 @notes         VARCHAR(5000)
)
AS
    BEGIN
        INSERT INTO tbl_companycontact
        (CompanyCountryID, 
         CompanyCityID, 
         CompanyIndustryID, 
         CompanyBusinessAreaID, 
         CompanyName, 
         CompanyWebSite, 
         CompanyAddress, 
         CompanyBusinessDesc, 
         CompanyZip, 
         CompanyPhone, 
         CompanyFax, 
         CompanyComments
        )
               SELECT @country, 
                      @city, 
                      @industry, 
                      @sector, 
                      @companyName, 
                      @website, 
                      @headoffice, 
                      @businessDescp, 
                      @zipCode, 
                      @pho, 
                      @fax, 
                      @notes;
        DECLARE @id INT;
        SET @id = SCOPE_IDENTITY();
        IF @companyType <> ''
            BEGIN
                INSERT INTO tbl_CompanyContactType
                (CompanyContactID, 
                 ContactTypeID
                )
                       SELECT @id, 
                              ContactTypesID
                       FROM tbl_ContactType
                       WHERE contacttypename = @companyType;
        END;
        SELECT 1 result;
    END;
