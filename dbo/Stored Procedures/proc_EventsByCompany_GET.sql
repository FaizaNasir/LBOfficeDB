CREATE PROCEDURE [dbo].[proc_EventsByCompany_GET] @RoleID    INT = NULL, 
                                                  @CompanyID INT = NULL
AS
    BEGIN
        --select * from tbl_EventCompanies
        SELECT e.*
        FROM tbl_Events E
             INNER JOIN tbl_EventCompanies EC ON E.EventID = EC.EventID
        WHERE EC.CompanyID = @CompanyID;
    END;
