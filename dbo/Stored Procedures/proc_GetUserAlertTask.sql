
-- created by : Syed Zain ALi      
-- [proc_GetUserAlerttask] 'david'      

CREATE PROC [dbo].[proc_GetUserAlertTask] @userName VARCHAR(1000)
AS
     DECLARE @currentIndividualID INT;
     SELECT @currentIndividualID = IndividualID
     FROM tbl_Individualuser
     WHERE UserName = @userName;
     SELECT TaskName, 
            dbo.[F_GetLinkToDealByTaskID](t.taskid) LinkToDeal, 
            TaskStatus, 
            EndDateTime, 
            TaskID
     FROM tbl_Tasks t
          JOIN tbl_AlertInterval ai ON t.AlertIntervalID = ai.AlertIntervalID
     WHERE DATEADD(hour, (-intervaldelay), EndDateTime) < GETDATE()
           AND ISNULL(t.Dismissed, 0) = 0
           AND EndDateTime > GETDATE()
           AND (ISNULL(t.IsPrivacy, 0) = 0
                OR EXISTS
     (
         SELECT TOP 1 1
         FROM tbl_tasklinked ma
         WHERE ma.taskID = t.taskID
               AND ma.isMCuser = 1
               AND ma.objectID = @currentIndividualID
     ))
     ORDER BY EndDateTime;
