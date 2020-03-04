CREATE FUNCTION [dbo].[F_GetLPEmailConfigDetail]
(@LPEmailConfigID INT, 
 @isCC            BIT
)
RETURNS VARCHAR(5000)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(5000);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' , ', '') + IndividualEmail
         FROM tbl_LPEmailConfigDetail cct
              JOIN tbl_ContactIndividual ct ON ct.IndividualID = cct.ContactID
         WHERE cct.LPEmailConfigID = @LPEmailConfigID
               AND IsCC = @isCC;
         RETURN @VouvherNo;
     END;
