CREATE PROCEDURE [dbo].[proc_CompanyIndividual_GET] @CompanyContactID INT = NULL
AS
    BEGIN
        SELECT [CompanyContactID], 
               [ContactIndividualID]
        FROM tbl_CompanyIndividuals
        WHERE companycontactid = ISNULL(@CompanyContactID, companycontactid)
              AND TeamTypeName = 'Executive Team';
    END;
