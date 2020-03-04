CREATE PROCEDURE [dbo].[proc_Report_CompanyTeamDetails] --1,'Executive Team'   
@CompanyContactID INT          = NULL,  
--@IndividualContactID int=NULL,  
@TeamTypeName     VARCHAR(100) = NULL
AS
    BEGIN
        SELECT I.contactindividualID AS IndividualID
        FROM tbl_CompanyIndividuals AS I
             INNER JOIN tbl_CompanyContact AS C ON I.CompanyContactID = C.CompanyContactID
             INNER JOIN tbl_ContactIndividual AS CI ON CI.IndividualID = I.ContactIndividualID
        WHERE I.CompanyContactID = ISNULL(@CompanyContactID, I.CompanyContactID)  
              --AND I.ContactIndividualID = ISNULL(@IndividualContactID,I.ContactIndividualID)  
              AND I.TeamTypeName = ISNULL(@TeamTypeName, I.TeamTypeName);
    END;  
