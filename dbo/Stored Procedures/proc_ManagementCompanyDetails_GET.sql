CREATE PROCEDURE [dbo].[proc_ManagementCompanyDetails_GET]
AS
    BEGIN
        SELECT *
        FROM tbl_CompanyContact
        WHERE CompanyContactID =
        (
            SELECT ParameterValue
            FROM tbl_defaultParameters
            WHERE ParameterName = 'ManagementCompanyID'
        );
    END;
