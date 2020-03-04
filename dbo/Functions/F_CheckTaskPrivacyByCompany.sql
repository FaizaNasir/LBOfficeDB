CREATE FUNCTION [dbo].[F_CheckTaskPrivacyByCompany]
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
                  INNER JOIN tbl_TaskLinked ON T.TaskID = tbl_TaskLinked.TaskID
                  INNER JOIN tbl_TaskMCContacts ON tbl_TaskMCContacts.TaskID = T.TaskID
             WHERE tbl_TaskLinked.TaskID = @TaskID
                   AND tbl_TaskMCContacts.IndividualID = @CurrentUserID
                   AND tbl_TaskMCContacts.IsExternalAdvisor = 1
         );
         RETURN ISNULL(@TaskIDRetrun, 'Busy');
     END;
