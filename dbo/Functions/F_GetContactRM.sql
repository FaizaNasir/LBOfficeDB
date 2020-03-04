CREATE FUNCTION [dbo].[F_GetContactRM]
(@individualId INT
)
RETURNS VARCHAR(5000)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(5000);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ',', '') + ISNULL(ct.IndividualLastName, '') + ' ' + ISNULL(ct.IndividualFirstName, '')
         FROM tbl_ContactIndividualRM cct
              JOIN tbl_ContactIndividual ct ON ct.IndividualId = cct.ManagementCompanyIndividualID
         WHERE cct.IndividualId = @individualId;
         RETURN @VouvherNo;
     END;
