CREATE PROCEDURE [dbo].[proc_GET_CompanyID] @CompanyName VARCHAR(MAX) = NULL
AS
    BEGIN
        SELECT CompanyContactID
        FROM [tbl_CompanyContact]
        WHERE CompanyName = ISNULL(@CompanyName, CompanyName);
    END;
