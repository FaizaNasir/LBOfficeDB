CREATE FUNCTION [dbo].[F_GetCompanyTypeNames]
(@companyId INT
)
RETURNS VARCHAR(500)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(500);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ',', '') + ContactTypename
         FROM
         (
             SELECT DISTINCT 
                    ContactTypename
             FROM tbl_CompanyContactType cct
                  JOIN tbl_ContactType ct ON ct.ContactTypesId = cct.ContactTypeId
             WHERE cct.companycontactId = @companyId
         ) t;
         RETURN @VouvherNo;
     END;
