CREATE PROCEDURE [dbo].[proc_companyOptionalBis_GetEconomicBeneficairies] @companyId INT
AS
     SELECT ci.IndividualTitle, 
            ci.IndividualID, 
            ci.IndividualFullName, 
            ci.IndividualFirstName, 
            ci.IndividualMiddleName, 
            ci.IndividualLastName
     FROM tbl_CompanyOptionalBis_EconomicBeneficiaries
          LEFT JOIN tbl_ContactIndividual ci ON ci.IndividualID = ContactId
     WHERE CompanyId = @companyId;
