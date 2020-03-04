
-- select   dbo.[F_GetLinkToCompanyByTaskID](378)        

CREATE FUNCTION [dbo].[F_GetLinkToCompanyByTaskID]
(@taskID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @taskIndividuals VARCHAR(MAX);
         SET @taskIndividuals = '';
         SELECT @taskIndividuals = @taskIndividuals + CompanyName + ', '
         FROM tbl_CompanyContact(NOLOCK) cc
              JOIN tbl_TaskLinked(NOLOCK) tl ON tl.ObjectID = cc.CompanyContactID
         WHERE tl.TaskID = @taskID
               AND tl.ModuleID = 5
               AND ISNULL(IsExternalAdvisor, 0) = 0;
         IF @taskIndividuals <> ''
             SET @taskIndividuals =
             (
                 SELECT SUBSTRING(@taskIndividuals, 0, LEN(@taskIndividuals))
             );
         RETURN @taskIndividuals;
     END;
