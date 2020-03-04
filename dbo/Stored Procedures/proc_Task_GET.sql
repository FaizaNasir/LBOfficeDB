CREATE PROCEDURE [dbo].[proc_Task_GET] @TaskID   INT          = NULL, 
                                       @TaskName VARCHAR(MAX) = NULL
AS
    BEGIN
        SELECT TaskID, 
               TaskName, 
               TaskDescription, 
               StartingDateTime, 
               EndDateTime, 
               TaskStatus, 
               TaskCost,  
               --TaskAlertDateTime,  
               CurrencyID, 
               OperationID,  
               --TaskAlert,  
               EstimatedDuration, 
               FinalDuration, 
               IsPrivacy, 
               RecurringType, 
               Duration, 
               ExternalAdvisorsID, 
               CurrencyID, 
               TaskComments, 
               RecurringGroupID, 
               ParentTaskID
        FROM tbl_Tasks
        WHERE TaskID = ISNULL(@TaskID, TaskID)
              AND TaskName = ISNULL(@TaskName, TaskName);
    END;
