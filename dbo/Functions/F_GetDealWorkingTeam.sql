CREATE FUNCTION [dbo].[F_GetDealWorkingTeam]
(@DealID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' , ', '') + ci.IndividualFullName
         FROM tbl_DealTeam DT
              JOIN tbl_ContactIndividual ci ON DT.IndividualID = ci.IndividualID
                                               AND DT.IsTeamLead = 0
         WHERE DT.DealID = @DealID;
         RETURN @VouvherNo;
     END;
