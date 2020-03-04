CREATE FUNCTION [dbo].[F_CheckTaskPrivacyByIndividual]
(@TaskID        INT, 
 @CurrentUserID INT
)
RETURNS VARCHAR(100)
AS
     BEGIN
         DECLARE @TaskIDRetrun VARCHAR(100);
         SELECT @TaskIDRetrun =
         (
             SELECT T.TaskName
             FROM [dbo].[tbl_tasks] T
                  INNER JOIN tbl_TaskMCContacts tm ON T.TaskID = tm.TaskID
             WHERE tm.IndividualID = @CurrentUserID
                   AND tm.TaskID = @TaskID
                   AND IsExternalAdvisor = 1
         );
         RETURN ISNULL(@TaskIDRetrun, 'Busy');
     END;
