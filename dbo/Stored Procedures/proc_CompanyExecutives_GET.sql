CREATE PROCEDURE [dbo].[proc_CompanyExecutives_GET] --254,'Executive Team' 
(@CompanyContactID INT          = NULL, 
 @TeamTypeName     VARCHAR(100) = NULL
)
AS
    BEGIN
        SELECT I.CompanyContactID AS CompanyID, 
               I.ContactIndividualID, 
               I.TeamTypeName, 
               I.ContactPositionInCompany, 
               CI.IndividualFirstName AS 'ExecutiveFirstName', 
               CI.IndividualMiddleName AS 'ExecutiveMiddleName', 
               CI.IndividualLastName AS 'ExecutiveLastName', 
               CI.IndividualFullName AS 'ExecutiveFullName', 
               RM.ManagementCompanyIndividualID, 
               MCI.IndividualFirstName AS 'RMFirstName', 
               MCI.IndividualMiddleName AS 'RMMiddleName', 
               MCI.IndividualLastName AS 'RMLastName', 
               MCI.IndividualFullName AS 'RMFullName'
        FROM tbl_CompanyIndividuals AS I
             INNER JOIN tbl_ContactIndividual AS CI ON CI.IndividualID = I.ContactIndividualID
             LEFT OUTER JOIN tbl_ContactIndividualRM RM ON RM.IndividualId = CI.IndividualID
                                                           AND RM.IsMain = 1
             LEFT OUTER JOIN tbl_ContactIndividual AS MCI ON MCI.IndividualID = RM.ManagementCompanyIndividualID
        WHERE I.CompanyContactID = ISNULL(@CompanyContactID, I.CompanyContactID)
              AND I.TeamTypeName = ISNULL(@TeamTypeName, I.TeamTypeName);
    END;
