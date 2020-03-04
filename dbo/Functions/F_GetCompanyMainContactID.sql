CREATE FUNCTION [dbo].[F_GetCompanyMainContactID]
(@companyId INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @VouvherNo INT;

         --@VouvherNo = COALESCE(@VouvherNo+',' ,'') + Name  

         SELECT @VouvherNo = CI.IndividualID
         FROM tbl_CompanyIndividuals AS I
              INNER JOIN tbl_CompanyContact AS C ON I.CompanyContactID = C.CompanyContactID
              INNER JOIN tbl_ContactIndividual AS CI ON CI.IndividualID = I.ContactIndividualID
         WHERE C.CompanyContactID = @companyId
               AND I.isMainIndividual = 1;
         RETURN @VouvherNo;
     END;
