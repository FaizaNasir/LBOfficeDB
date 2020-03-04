
-- [proc_ManagementCompanyUsers_GET] '3 Nov, 2013'    

CREATE PROCEDURE [dbo].[proc_ManagementCompanyUsers_GET](@leftOnDate DATETIME = NULL)
AS
     IF @leftOnDate > GETDATE()
         SET @leftOnDate = GETDATE();
    BEGIN
        SELECT c.CompanyIndividualID, 
               c.CompanyContactID AS individualCompanyID, 
               c.ContactIndividualID, 
               c.TeamTypeName, 
               c.isMainCompany, 
               c.ContactPositionInCompany, 
               c.ContactDepartmentInCompany, 
               c.ContactDateOfJoiningInCompany, 
               c.ContactDateOfLeavingFromCompany, 
               c.ContactDirectLineInCompany, 
               c.ContactDirectFaxInCompany, 
               c.ContactFaxNumberInCompany, 
               c.ContactMobileNumberInCompany, 
               c.ContactEmailAddressInCompany, 
               c.ContactPrivateAssitantID, 
               i.IndividualID, 
               i.IndividualCountryID, 
               i.IndividualCityID, 
               i.IndividualTitle, 
               i.IndividualFirstName, 
               i.IndividualMiddleName, 
               i.IndividualLastName, 
               i.IndividualFullName, 
               i.IndividualDOB, 
               i.IndividualPhone, 
               i.IndividualMobile, 
               i.IndividualFax, 
               i.IndividualEmail, 
               i.IndividualAddress, 
               i.IndividualZipCode, 
               i.IndividualPOBox, 
               i.IndividualPhoto, 
               i.IndividualBackground, 
               i.IndividualComments, 
               i.IndividualKnowledgeID, 
               i.IndividualFacebookID, 
               i.IndividualLinkedInID, 
               i.IndividualSkypeID, 
               i.IndividualTwitterID, 
               i.IndividualOtherSNIDs,
               CASE
                   WHEN ISNULL(c.ContactDateOfLeavingFromCompany, GETDATE()) < GETDATE()
                   THEN 1
                   ELSE 0
               END IsLeftOn
        FROM tbl_ContactIndividual I
             INNER JOIN tbl_CompanyIndividuals C ON I.IndividualID = C.ContactIndividualID
             LEFT JOIN tbl_CompanyContactType T ON T.CompanyContactID = C.CompanyContactID
                                                   AND T.ContactTypeID = 1
        WHERE C.CompanyContactID =
        (
            SELECT ParameterValue
            FROM tbl_defaultParameters
            WHERE ParameterName = 'ManagementCompanyID'
        )
              AND ISNULL(c.ContactDateOfLeavingFromCompany, GETDATE()) >= ISNULL(@leftOnDate, GETDATE())
        ORDER BY i.IndividualFullName;
    END;
