CREATE PROCEDURE [dbo].[proc_ContactIndividualRMByIndividualId_GET] @IndividualId INT = NULL
AS
    BEGIN
        SELECT RM.[Id], 
               RM.[IndividualId], 
               RM.[ManagementCompanyIndividualID], 
               RM.[IsMain], 
               CI.[IndividualFullName]
        FROM [LBOffice].[dbo].[tbl_ContactIndividualRM] RM
             JOIN [LBOffice].[dbo].[tbl_ContactIndividual] CI ON RM.[ManagementCompanyIndividualID] = CI.[IndividualID]
        WHERE RM.[IndividualId] = @IndividualId;

        --select * from tbl_ContactIndividual tbl_CompanyContact
    END;
