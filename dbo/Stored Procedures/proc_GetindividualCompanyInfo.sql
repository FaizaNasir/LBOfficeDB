
-- proc_GetindividualCompanyInfo 419

CREATE PROC [dbo].[proc_GetindividualCompanyInfo](@individualid INT)
AS
     SELECT c.CompanyIndividualID, 
            c.ContactDateOfJoiningInCompany, 
            c.ContactDateOfLeavingFromCompany, 
            i.IndividualID, 
            i.IndividualFullName, 
            i.IndividualFirstName, 
            i.IndividualMiddleName, 
            i.IndividualLastName, 
            ISNULL(
     (
         SELECT TOP 1 1
         FROM tbl_defaultParameters(NOLOCK) dp
         WHERE dp.ParameterValue = c.CompanyContactID
               AND ParameterName = 'ManagementCompanyID'
     ), 0) ParameterValue
     FROM tbl_CompanyIndividuals c(NOLOCK)
          JOIN tbl_ContactIndividual i(NOLOCK) ON I.IndividualID = C.ContactIndividualID
     WHERE i.individualid = @individualid
     ORDER BY ParameterValue DESC;
