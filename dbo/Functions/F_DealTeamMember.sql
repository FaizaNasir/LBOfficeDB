CREATE FUNCTION [dbo].[F_DealTeamMember]
(@id     INT, 
 @isMain BIT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @ConcatString VARCHAR(MAX);
         SELECT @ConcatString = COALESCE(@ConcatString + ',', '') + IndividualFullName
         FROM tbl_DealTeam
              LEFT OUTER JOIN tbl_ContactIndividual ON tbl_DealTeam.IndividualID = tbl_ContactIndividual.IndividualID
         WHERE DealID = @id
               AND 1 = CASE
                           WHEN @isMain IS NULL
                           THEN 1
                           WHEN @isMain = IsTeamLead
                           THEN 1
                           ELSE 0
                       END;
         RETURN
         (
             SELECT @ConcatString
         );
     END;
