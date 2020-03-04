
-- select   dbo.[F_GetLinkToDealByTaskID](378)        

CREATE FUNCTION [dbo].[F_GetLinkToDealByTaskID]
(@taskID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @taskIndividuals VARCHAR(MAX);
         SET @taskIndividuals = '';
         SELECT @taskIndividuals = @taskIndividuals + DealName + ', '
         FROM tbl_Deals(NOLOCK) cc
              JOIN tbl_TaskLinked(NOLOCK) tl ON tl.ObjectID = cc.DealID
         WHERE tl.TaskID = @taskID
               AND tl.ModuleID = 6
               AND ISNULL(IsExternalAdvisor, 0) = 0;
         IF @taskIndividuals <> ''
             SET @taskIndividuals =
             (
                 SELECT SUBSTRING(@taskIndividuals, 0, LEN(@taskIndividuals))
             );
         RETURN @taskIndividuals;
     END;
