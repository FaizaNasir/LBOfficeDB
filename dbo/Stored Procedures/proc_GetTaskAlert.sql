
-- created by	:	Syed Zain ALi
-- proc_GetTaskAlert 'david'      

CREATE PROC [dbo].[proc_GetTaskAlert] @userName VARCHAR(1000)
AS
     DECLARE @currentIndividualID INT;
     SELECT @currentIndividualID = IndividualID
     FROM tbl_Individualuser
     WHERE UserName = @userName;
     SELECT TaskName, 
            enddatetime, 
            taskstatus, 
            t.taskid, 
            [dbo].[F_GetLinkToDealByTaskID](t.taskid) LinkedToDeals
     FROM tbl_Tasks t
          JOIN tbl_tasklinked ma ON ma.taskID = t.taskID
                                    AND ma.isMCuser = 1
                                    AND ma.objectID = @currentIndividualID
     WHERE enddatetime > GETDATE()
     ORDER BY EndDateTime;
