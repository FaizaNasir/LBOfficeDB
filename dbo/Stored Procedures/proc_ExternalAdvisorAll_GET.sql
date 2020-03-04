CREATE PROCEDURE [dbo].[proc_ExternalAdvisorAll_GET] @CompanyID INT = NULL
AS
    BEGIN
        SELECT I.*
        FROM tbl_ContactIndividual I
             INNER JOIN tbl_ContactIndividualContactTypes T ON I.IndividualID = T.ContactIndividualID
             LEFT JOIN tbl_CompanyIndividuals CI ON I.IndividualID = CI.ContactIndividualID
        WHERE T.ContactIndividualTypeID = 7
              AND CI.CompanyContactID = ISNULL(@CompanyID, CI.CompanyContactID);
    END;
