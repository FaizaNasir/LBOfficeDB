CREATE PROCEDURE [dbo].[proc_CompanyIndividualTeamDetails_GET] --null,487,null   

@CompanyContactID    INT          = NULL, 
@IndividualContactID INT          = NULL, 
@TeamTypeName        VARCHAR(100) = NULL
AS
    BEGIN
        SELECT I.CompanyIndividualID AS IndividualID, 
               I.CompanyContactID AS CompanyID, 
               I.ContactIndividualID, 
               I.TeamTypeName, 
               I.isMainCompany, 
               I.isMainIndividual, 
               I.ContactPositionInCompany, 
               I.ContactDepartmentInCompany, 
               I.ContactDateOfJoiningInCompany, 
               I.ContactDateOfLeavingFromCompany, 
               I.ContactDirectLineInCompany, 
               I.ContactDirectFaxInCompany, 
               I.ContactFaxNumberInCompany, 
               I.ContactMobileNumberInCompany, 
               I.ContactEmailAddressInCompany, 
               I.ContactPrivateAssitantID, 
               C.CompanyContactID AS Expr1, 
               C.CompanyLogo, 
               C.ExternalAdvisorTypeID, 
               C.CompanyCountryID, 
               C.CompanyCityID, 
               C.CompanyMainIndividualID, 
               C.CompanyStatus, 
               C.CompanyIndustryID, 
               C.CompanyBusinessAreaID, 
               C.CompanyBusinessDesc, 
               C.CompanyName, 
               C.CompanyWebSite, 
               C.CompanyAddress, 
               C.CompanyZip, 
               C.CompanyPOBox, 
               C.CompanyPhone, 
               C.CompanyFax, 
               C.CompanyCreationDate, 
               C.CompanyCreatedDate, 
               C.CompanyStartCollaborationDate, 
               C.CompanyActivity, 
               C.CompanyLinkedIn, 
               C.CompanyFacebook, 
               C.CompanyTwitter, 
               CI.IndividualID AS CIIndividualID, 
               CI.IndividualCountryID, 
               CI.IndividualCityID, 
               CI.IndividualTitle, 
               ISNULL(CI.IndividualFirstName,'')IndividualFirstName, 
               ISNULL(CI.IndividualMiddleName,'')IndividualMiddleName, 
               ISNULL(CI.IndividualLastName,'')IndividualLastName, 
               CI.IndividualFullName, 
               CI.IndividualDOB, 
               CI.IndividualPhone, 
               CI.IndividualMobile, 
               CI.IndividualFax, 
               CI.IndividualEmail, 
               CI.IndividualAddress, 
               CI.IndividualZipCode, 
               CI.IndividualPOBox, 
               CI.IndividualPhoto, 
               CI.IndividualBackground, 
               CI.IndividualComments, 
               CI.IndividualKnowledgeID, 
               CI.IndividualFacebookID, 
               CI.IndividualLinkedInID, 
               CI.IndividualSkypeID, 
               CI.IndividualTwitterID, 
               CI.IndividualOtherSNIDs, 
               I.ContactRole, 
               I.OfficeID, 
        (
            SELECT TOP 1 OfficeCity
            FROM tbl_companyoffice co
            WHERE co.OfficeID = i.OfficeID
        ) City
        FROM tbl_CompanyIndividuals AS I
             INNER JOIN tbl_CompanyContact AS C ON I.CompanyContactID = C.CompanyContactID
             INNER JOIN tbl_ContactIndividual AS CI ON CI.IndividualID = I.ContactIndividualID
        WHERE I.CompanyContactID = ISNULL(@CompanyContactID, I.CompanyContactID)
              AND I.ContactIndividualID = ISNULL(@IndividualContactID, I.ContactIndividualID)
              AND I.TeamTypeName = ISNULL(@TeamTypeName, I.TeamTypeName);
    END;  
