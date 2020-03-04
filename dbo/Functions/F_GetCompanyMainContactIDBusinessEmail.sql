CREATE FUNCTION [dbo].[F_GetCompanyMainContactIDBusinessEmail]
(@companyId INT
)
RETURNS VARCHAR(100)
AS
     BEGIN
         DECLARE @email VARCHAR(100);

         --@VouvherNo = COALESCE(@VouvherNo+',' ,'') + Name      

         SELECT @email = ComI.ContactEmailAddressInCompany
         FROM tbl_CompanyIndividuals AS I
              INNER JOIN tbl_CompanyContact AS C ON I.CompanyContactID = C.CompanyContactID
              INNER JOIN tbl_ContactIndividual AS CI ON CI.IndividualID = I.ContactIndividualID
                                                        AND I.isMainIndividual = 1
              JOIN tbl_CompanyIndividuals comi ON comi.ContactIndividualID = CI.IndividualID
                                                  AND comi.isMainCompany = 1
         WHERE C.CompanyContactID = @companyId;
         RETURN @email;
     END;  
