CREATE FUNCTION [dbo].[F_GetCompanyMainContact]
(@companyId INT
)
RETURNS VARCHAR(50)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(50);

         --@VouvherNo = COALESCE(@VouvherNo+',' ,'') + Name

         SELECT @VouvherNo = CI.IndividualFullName
         FROM tbl_CompanyIndividuals AS I
              INNER JOIN tbl_CompanyContact AS C ON I.CompanyContactID = C.CompanyContactID
              INNER JOIN tbl_ContactIndividual AS CI ON CI.IndividualID = I.ContactIndividualID
         WHERE C.CompanyContactID = @companyId
               AND I.isMainIndividual = 1;
         RETURN @VouvherNo;
     END;
