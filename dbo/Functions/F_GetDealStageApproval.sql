CREATE FUNCTION [dbo].[F_GetDealStageApproval]
(@DealID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' , ', '') + ci.IndividualFullName
         FROM tbl_DealStageApproval DSA
              JOIN tbl_ContactIndividual ci ON DSA.ApprovedByID = ci.IndividualID
         WHERE DSA.DealID = @DealID;
         RETURN @VouvherNo;
     END;
