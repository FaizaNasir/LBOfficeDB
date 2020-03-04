
-- created by : Syed Zain Ali  

/*  

  

exec [dbo].[proc_Task_SET] @TaskID=-1,@TaskName='251',  

@StartingDateTime='2013-11-01 00:00:00',  

@EndDateTime='2013-11-22 00:00:00',  

@TaskStatus='Proposed',@AlertComments=NULL,@TaskDescription='',  

@EstimatedDuration=NULL,@FinalDuration=NULL,@TaskCost=NULL,  

@IsPrivacy=0,@RecurringType=NULL,@Duration=0,@ExternalAdvisorsID=NULL,  

@CurrencyID=108,@TaskComments='',@RecurringGroupID=1,@parentTaskID=-1,  

@budget=NULL,@alertIntervalID=1,@workDuration=1  

  

*/

CREATE PROCEDURE [dbo].[proc_Task_SET]
(@TaskID             INT, 
 @TaskName           VARCHAR(100), 
 @StartingDateTime   DATETIME, 
 @EndDateTime        DATETIME, 
 @TaskStatus         VARCHAR(100), 
 @AlertComments      VARCHAR(2000), 
 @TaskDescription    VARCHAR(MAX), 
 @EstimatedDuration  INT, 
 @FinalDuration      INT, 
 @TaskCost           INT, 
 @IsPrivacy          BIT, 
 @RecurringType      VARCHAR(50), 
 @Duration           INT, 
 @ExternalAdvisorsID INT, 
 @CurrencyID         INT, 
 @TaskComments       VARCHAR(MAX), 
 @RecurringGroupID   INT, 
 @parentTaskID       INT            = -1, 
 @budget             DECIMAL(18, 2)  = NULL, 
 @alertIntervalID    INT, 
 @workDuration       INT
)
AS
     IF @parentTaskID = -1
         SET @parentTaskID = NULL;
    BEGIN
        IF(@TaskID IS NULL
           OR @TaskID = -1)
            BEGIN
                INSERT INTO [dbo].[tbl_Tasks]
                (TaskName, 
                 StartingDateTime, 
                 EndDateTime, 
                 TaskStatus, 
                 AlertComments, 
                 TaskDescription, 
                 EstimatedDuration, 
                 FinalDuration, 
                 TaskCost, 
                 IsPrivacy, 
                 RecurringType, 
                 Duration, 
                 ExternalAdvisorsID, 
                 CurrencyID, 
                 TaskComments, 
                 RecurringGroupID, 
                 parenttaskid, 
                 budget, 
                 AlertIntervalID, 
                 workDuration
                )
                VALUES
                (@TaskName, 
                 @StartingDateTime, 
                 @EndDateTime, 
                 @TaskStatus, 
                 @AlertComments, 
                 @TaskDescription, 
                 @EstimatedDuration, 
                 @FinalDuration, 
                 @TaskCost, 
                 @IsPrivacy, 
                 @RecurringType, 
                 @Duration, 
                 @ExternalAdvisorsID, 
                 @CurrencyID, 
                 @TaskComments, 
                 @RecurringGroupID, 
                 @parentTaskID, 
                 @budget, 
                 @alertIntervalID, 
                 @workDuration
                );
                SET @TaskID =
                (
                    SELECT SCOPE_IDENTITY()
                );
        END;
            ELSE
            BEGIN
                UPDATE [dbo].[tbl_Tasks]
                  SET 
                      TaskName = ISNULL(@TaskName, TaskName), 
                      StartingDateTime = ISNULL(@StartingDateTime, StartingDateTime), 
                      EndDateTime = ISNULL(@EndDateTime, EndDateTime), 
                      TaskStatus = ISNULL(@TaskStatus, TaskStatus), 
                      AlertComments = ISNULL(@AlertComments, AlertComments), 
                      TaskDescription = ISNULL(@TaskDescription, TaskDescription), 
                      EstimatedDuration = ISNULL(@EstimatedDuration, EstimatedDuration), 
                      FinalDuration = ISNULL(@FinalDuration, FinalDuration), 
                      TaskCost = ISNULL(@TaskCost, TaskCost), 
                      IsPrivacy = ISNULL(@IsPrivacy, IsPrivacy), 
                      RecurringType = ISNULL(@RecurringType, RecurringType), 
                      Duration = ISNULL(@Duration, Duration), 
                      ExternalAdvisorsID = ISNULL(@ExternalAdvisorsID, ExternalAdvisorsID), 
                      CurrencyID = ISNULL(@CurrencyID, CurrencyID), 
                      TaskComments = ISNULL(@TaskComments, TaskComments), 
                      RecurringGroupID = ISNULL(@RecurringGroupID, RecurringGroupID), 
                      Budget = ISNULL(@budget, Budget), 
                      AlertIntervalID = ISNULL(@alertIntervalID, AlertIntervalID), 
                      workDuration = ISNULL(@workDuration, workDuration)
                WHERE TaskID = @TaskID;
        END;
        SELECT 'Success' AS Success, 
               @TaskID AS TaskID;
    END;
