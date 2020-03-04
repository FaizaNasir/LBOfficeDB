CREATE PROCEDURE [dbo].[proc_EventsByIndividual_GET] @RoleID       INT = NULL, 
                                                     @IndividualID INT = NULL
AS
    BEGIN
        --select * from tbl_EventCompanies
        SELECT E.*
        FROM tbl_Events E
             INNER JOIN tbl_EventIndividuals EC ON E.EventID = EC.EventID
        WHERE EC.IndividualID = @IndividualID;
    END;
