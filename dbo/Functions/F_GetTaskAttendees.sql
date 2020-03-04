CREATE FUNCTION [dbo].[F_GetTaskAttendees]
(@taskID            INT, 
 @isMCUser          BIT, 
 @IsExternalAdvisor BIT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @taskIndividuals VARCHAR(MAX);
         SET @taskIndividuals = '';
         SELECT @taskIndividuals = @taskIndividuals + IndividualFullName + ', '
         FROM tbl_ContactIndividual(NOLOCK) ind
              JOIN tbl_TaskLinked(NOLOCK) tc ON tc.ObjectID = ind.IndividualID
         WHERE tc.TaskID = @taskID
               AND tc.moduleid = 4
               AND ISNULL(tc.isMCUser, 0) = @isMCUser
               AND ISNULL(IsExternalAdvisor, 0) = @IsExternalAdvisor;
         IF @taskIndividuals <> ''
             SET @taskIndividuals =
             (
                 SELECT SUBSTRING(@taskIndividuals, 0, LEN(@taskIndividuals))
             );
         RETURN @taskIndividuals;
     END;
