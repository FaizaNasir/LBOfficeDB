CREATE PROCEDURE [dbo].[proc_Task_Search] --'semi','and',null,null,'01/jan/2000','30/apr/2013','and','and',null,null
(@FreeText        VARCHAR(MAX), 
 @AndOR           VARCHAR(100), --='AND',
 @TaskName        VARCHAR(100), 
 @TaskDesc        VARCHAR(MAX), 
 @StartDate       DATETIME     = NULL, 
 @EndDate         DATETIME     = NULL, 
 @MMC             VARCHAR(100), --='AND',
 @ExtranalAdvisor VARCHAR(100), --='AND',
 @IndividualID    VARCHAR(50)  = NULL, 
 @CompaniesID     VARCHAR(50)  = NULL
)
AS
    BEGIN
        SELECT tbl_Tasks.[TaskID], 
               tbl_Recurring_Task.RecurringID, 
               [TaskName], 
               [TaskDescription], 
               tbl_Recurring_Task.StartDate AS StartingDateTime, 
               tbl_Recurring_Task.EndDate AS EndDateTime, 
               [TaskStatus], 
               [TaskCost], 
               [TaskAlertDateTime], 
               [CurrencyID], 
               [OperationID], 
               [TaskAlert], 
               [EstimatedDuration], 
               [FinalDuration], 
               [IsPrivacy], 
               [RecurringType], 
               [Duration]
        FROM [dbo].[tbl_Tasks]
             LEFT OUTER JOIN tbl_Recurring_Task ON tbl_Tasks.TaskID = tbl_Recurring_Task.TaskID
             LEFT OUTER JOIN tbl_TaskExternalAdvisors ON tbl_Tasks.TaskID = tbl_TaskExternalAdvisors.TaskID
        --	  LEFT OUTER JOIN tbl_ContactIndividual on tbl_ContactIndividual.IndividualID =  tbl_TaskExternalAdvisors.ExternalAdvisorID

        WHERE(tbl_Tasks.TaskName LIKE ISNULL('%' + @FreeText + '%', tbl_Tasks.TaskName)
              OR tbl_Tasks.TaskDescription LIKE ISNULL('%' + @FreeText + '%', tbl_Tasks.TaskDescription))
             AND tbl_Tasks.StartingDateTime BETWEEN ISNULL(@StartDate, tbl_Tasks.StartingDateTime) AND ISNULL(@EndDate, tbl_Tasks.StartingDateTime);
        --	AND tbl_ContactIndividual.IndividualID  = ISNULL(@ExtranalAdvisor,tbl_TaskExternalAdvisors.ExternalAdvisorID) 

    END;
