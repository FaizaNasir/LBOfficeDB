CREATE PROCEDURE [dbo].[proc_companyOptionalBis_Get] @companyId INT
AS
     SELECT optional.CompanyId, 
            MassenaPrivateBanker, 
     (
         SELECT ISNULL(contact.IndividualFirstName + ' ' + contact.IndividualLastName, '')
         FROM tbl_ContactIndividual contact
         WHERE contact.IndividualID = optional.MassenaPrivateBanker
     ) AS MassenaPrivateBankerFullName, 
            DepositaryBank, 
     (
         SELECT ISNULL(company.CompanyName, '')
         FROM tbl_companycontact company
         WHERE company.CompanyContactID = optional.DepositaryBank
     ) AS DepositaryBankName, 
            b.InvestmentMode, 
     (
         SELECT ISNULL(mode.InvestmentModeName, '')
         FROM tbl_InvestmentMode mode
         WHERE mode.IdInvestmentMode = b.InvestmentMode
     ) AS InvestmentModeName, 
            GroupName, 
            Insurer, 
     (
         SELECT ISNULL(company.CompanyName, '')
         FROM tbl_companycontact company
         WHERE company.CompanyContactID = optional.Insurer
     ) AS InsurerName, 
            ContractReference, 
            Greetings1, 
            Greetings2, 
            b.Bank, 
            b.SWIFT, 
            b.IBAN, 
            AttentionTo, 
     (
         SELECT IndividualTitle
         FROM tbl_ContactIndividual contact
         WHERE contact.IndividualID = optional.AttentionTo
     ) AS AttentionToTitle, 
     (
         SELECT ISNULL(contact.IndividualFirstName + ' ' + contact.IndividualLastName, '')
         FROM tbl_ContactIndividual contact
         WHERE contact.IndividualID = optional.AttentionTo
     ) AS AttentionToFullName, 
     (
         SELECT ISNULL(contact.IndividualFirstName, '')
         FROM tbl_ContactIndividual contact
         WHERE contact.IndividualID = optional.AttentionTo
     ) AS AttentionToFirstName, 
     (
         SELECT ISNULL(contact.IndividualLastName, '')
         FROM tbl_ContactIndividual contact
         WHERE contact.IndividualID = optional.AttentionTo
     ) AS AttentionToLastName, 
            CountryID, 
     (
         SELECT ISNULL(country.CountryName, '')
         FROM tbl_Country country
         WHERE country.CountryID = optional.CountryID
     ) AS CountryName
     FROM tbl_companyOptionalBis optional
          OUTER APPLY
     (
         SELECT TOP 1 *
         FROM tbl_CompanyOptionalBis_Fund f
         WHERE f.CompanyId = optional.CompanyId
     ) b
     WHERE optional.CompanyId = @companyId;
