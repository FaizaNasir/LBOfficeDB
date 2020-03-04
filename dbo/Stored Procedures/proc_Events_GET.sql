CREATE PROCEDURE [dbo].[proc_Events_GET]-- 0,5																	
@RoleID  INT = NULL, 
@EventID INT = NULL
AS
    BEGIN
        --select * from tbl_EventCompanies
        SELECT *
        FROM tbl_Events E
        WHERE EventID = @EventID;
        SELECT *
        FROM tbl_Events E
             INNER JOIN tbl_EventIndividuals EC ON E.EventID = EC.EventID
             INNER JOIN tbl_ContactIndividual I ON EC.IndividualID = I.IndividualID
        WHERE E.EventID = @EventID;
        SELECT *
        FROM tbl_Events E
             INNER JOIN tbl_EventCompanies EC ON E.EventID = EC.EventID
             INNER JOIN tbl_CompanyContact C ON EC.CompanyID = C.CompanyContactID
        WHERE E.EventID = @EventID;
        SELECT *
        FROM tbl_Events E
             INNER JOIN tbl_EventAttendies EC ON E.EventID = EC.EventID
             INNER JOIN tbl_ContactIndividual I ON EC.ContactID = I.IndividualID
        WHERE E.EventID = @EventID;
    END;
