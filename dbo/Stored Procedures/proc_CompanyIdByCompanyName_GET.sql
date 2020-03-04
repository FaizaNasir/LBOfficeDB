CREATE PROCEDURE [dbo].[proc_CompanyIdByCompanyName_GET] @CompanyName VARCHAR(MAX)
AS
    BEGIN
        SELECT CompanyContactID, 
               CompanyName
        FROM tbl_CompanyContact
        WHERE CompanyName = @CompanyName;
    END;
