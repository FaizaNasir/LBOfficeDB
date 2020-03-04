﻿CREATE VIEW [dbo].[vw_ContactIndividualsWithCompanyContacts]
AS
     SELECT dbo.tbl_CompanyIndividuals.CompanyIndividualID, 
            dbo.tbl_CompanyIndividuals.CompanyContactID, 
            dbo.tbl_CompanyIndividuals.ContactIndividualID, 
            dbo.tbl_CompanyIndividuals.TeamTypeName, 
            dbo.tbl_CompanyIndividuals.isMainCompany, 
            dbo.tbl_CompanyIndividuals.ContactPositionInCompany, 
            dbo.tbl_CompanyIndividuals.ContactDepartmentInCompany, 
            dbo.tbl_CompanyIndividuals.ContactDateOfJoiningInCompany, 
            dbo.tbl_CompanyIndividuals.ContactDateOfLeavingFromCompany, 
            dbo.tbl_CompanyIndividuals.ContactDirectLineInCompany, 
            dbo.tbl_CompanyIndividuals.ContactDirectFaxInCompany, 
            dbo.tbl_CompanyIndividuals.ContactFaxNumberInCompany, 
            dbo.tbl_CompanyIndividuals.ContactMobileNumberInCompany, 
            dbo.tbl_CompanyIndividuals.ContactEmailAddressInCompany, 
            dbo.tbl_CompanyIndividuals.ContactPrivateAssitantID, 
            dbo.tbl_CompanyContact.CompanyName AS CompanyName, 
            dbo.tbl_CompanyContact.CompanyStatus AS CompanyStatus, 
            dbo.tbl_CompanyContact.CompanyMainIndividualID AS CompanyMainIndividualID, 
            dbo.tbl_CompanyContact.CompanyMainIndividualID AS CompanyCityID, 
            dbo.tbl_CompanyContact.CompanyCityID AS CompanyCountryID, 
            dbo.tbl_CompanyContact.CompanyCountryID AS ExternalAdvisorTypeID, 
            dbo.tbl_CompanyContact.CompanyLogo, 
            dbo.tbl_CompanyContact.CompanyIndustryID, 
            dbo.tbl_CompanyContact.CompanyBusinessAreaID, 
            dbo.tbl_CompanyContact.CompanyBusinessDesc, 
            dbo.tbl_CompanyContact.CompanyWebSite, 
            dbo.tbl_CompanyContact.CompanyAddress, 
            dbo.tbl_CompanyContact.CompanyZip, 
            dbo.tbl_CompanyContact.CompanyPOBox, 
            dbo.tbl_CompanyContact.CompanyPhone, 
            dbo.tbl_CompanyContact.CompanyFax, 
            dbo.tbl_CompanyContact.CompanyCreationDate, 
            dbo.tbl_CompanyContact.CompanyCreatedDate, 
            dbo.tbl_CompanyContact.CompanyStartCollaborationDate, 
            dbo.tbl_CompanyContact.CompanyActivity, 
            dbo.tbl_CompanyContact.CompanyFacebook, 
            dbo.tbl_CompanyContact.CompanyTwitter, 
            dbo.tbl_CompanyContact.CompanyLinkedIn, 
            dbo.tbl_CompanyContact.CompanyLinkedIn AS Expr1
     FROM dbo.tbl_CompanyIndividuals
          INNER JOIN dbo.tbl_CompanyContact ON dbo.tbl_CompanyIndividuals.CompanyContactID = dbo.tbl_CompanyContact.CompanyContactID;
