CREATE FUNCTION [dbo].[F_GetContactTypeNames]
(@individualId INT
)
RETURNS VARCHAR(500)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(500);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ',', '') + ContactTypename
         FROM tbl_ContactIndividualContactTypes cct
              JOIN tbl_ContactType ct ON ct.ContactTypesId = cct.ContactIndividualTypeID
         WHERE cct.ContactIndividualID = @individualId;
         RETURN @VouvherNo;
     END;
