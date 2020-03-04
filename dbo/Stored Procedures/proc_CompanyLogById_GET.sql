CREATE PROCEDURE [dbo].[proc_CompanyLogById_GET] @ID INT = NULL
AS
    BEGIN
        SELECT [Id], 
               [Company_Id], 
               [Value], 
               [Contact_Id], 
               [Comment], 
               [Log_Type]
        FROM tbl_CompanyLogs
        WHERE Id = @ID;

        --select * from tbl_ContactIndividual tbl_CompanyContact
    END;
