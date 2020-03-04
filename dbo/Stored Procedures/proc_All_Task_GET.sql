
/********************************************************************
** Name			    :	proc_All_Task_GET
** Author			    :	Zain Ali
** Create Date		    :	2 Jun, 2014
** 
** Description / Page   :	Action - All Task Grid
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------
** 01   4 Jun, 2014	    Zain Ali		Add Created Date Column
********************************************************************/

-- created by : syed zain ali                            

/*         
    

[dbo].[proc_All_Task_GET] @taskID=NULL,@taskName=NULL,@startingdateFrom=NULL,        

@startingdateTo=NULL,@endingdateFrom=NULL,@endingdateTo=NULL,@TaskStatus=NULL,        

@mcTeamMembers=NULL,@OtherIndividualID='-1',@companiesID=NULL,@externalTaskView=-1,        

@lnkDeal='8',@userName='admin',@isExcelReq=0        
    

*/

CREATE PROCEDURE [dbo].[proc_All_Task_GET]
(@taskID            INT           = NULL, 
 @taskName          VARCHAR(100)  = NULL, 
 @startingdateFrom  DATETIME      = NULL, 
 @startingdateTo    DATETIME      = NULL, 
 @endingdateFrom    DATETIME      = NULL, 
 @endingdateTo      DATETIME      = NULL, 
 @TaskStatus        VARCHAR(100)  = NULL, 
 @mcTeamMembers     VARCHAR(1000) = NULL, 
 @OtherIndividualID VARCHAR(1000) = NULL, 
 @companiesID       VARCHAR(1000) = NULL, 
 @externalTaskView  INT, 
 @lnkDeal           VARCHAR(1000) = NULL, 
 @lnkFund           VARCHAR(1000) = NULL, 
 @lnkPortfolio      VARCHAR(1000) = NULL, 
 @userName          VARCHAR(1000) = NULL, 
 @isExcelReq        BIT           = 0
)
AS
     DECLARE @currentIndividualID INT;
     SELECT @currentIndividualID = IndividualID
     FROM tbl_Individualuser
     WHERE UserName = @userName;
     IF @taskName = ''
         SET @taskName = NULL;
     IF @startingdateFrom = ''
         SET @startingdateFrom = NULL;
     IF @startingdateTo = ''
         SET @startingdateTo = NULL;
     IF @endingdateFrom = ''
         SET @endingdateFrom = NULL;
     IF @endingdateTo = ''
         SET @endingdateTo = NULL;
     IF @TaskStatus = ''
         SET @TaskStatus = NULL;
     IF @mcTeamMembers = ''
         SET @mcTeamMembers = NULL;
     IF @OtherIndividualID = '-1'
        OR @OtherIndividualID = ''
         SET @OtherIndividualID = NULL;
     IF @companiesID = ''
         SET @companiesID = NULL;
     IF @lnkDeal = ''
         SET @lnkDeal = NULL;
     IF @lnkFund = ''
         SET @lnkFund = NULL;
     IF @lnkPortfolio = ''
         SET @lnkPortfolio = NULL;
    BEGIN
        SELECT StartingDateTime, 
               EndDateTime, 
               TaskName,
               CASE
                   WHEN @isExcelReq = 1
                   THEN dbo.[F_GetTaskAttendees](t.TaskID, 1, 0)
                   ELSE ''
               END MCTeamMembers,
               CASE
                   WHEN @isExcelReq = 1
                   THEN dbo.[F_GetTaskAttendees](t.TaskID, 0, 0)
                   ELSE ''
               END OtherIndividual,
               CASE
                   WHEN @isExcelReq = 1
                   THEN dbo.[F_GetTaskAttendees](t.TaskID, 0, 1)
                   ELSE ''
               END ExternalAdvisor,
               CASE
                   WHEN @isExcelReq = 1
                   THEN dbo.[F_GetLinkToCompanyByTaskID](t.TaskID)
                   ELSE ''
               END LinkedCompanies, 
               TaskComments, 
        (
            SELECT COUNT(1)
            FROM tbl_Tasks t1
            WHERE t1.ParentTaskID = t.TaskID
        ) AS ChildCount, 
               t.parenttaskid, 
               0 AS RecurringID, 
               t.TaskID, 
               TaskDescription, 
               TaskStatus, 
               TaskCost,
               CASE
                   WHEN ISNULL(t.IsPrivacy, 0) = 0
                        OR EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_TaskLinked tc
            WHERE t.Taskid = tc.Taskid
                  AND tc.ismcuser = 1
                  AND tc.objectid = @currentIndividualID
                  AND tc.moduleid = 4
        )
                   THEN 0
                   WHEN t.IsPrivacy = 1
                   THEN 1
               END IsConfidential, 
               ISNULL(
        (
            SELECT IntervalDesc
            FROM tbl_AlertInterval ai
            WHERE ai.AlertIntervalID = t.AlertIntervalID
        ), '') IntervalDesc, 
               t.CurrencyID, 
               OperationID, 
               AlertComments, 
               ISNULL(EstimatedDuration, '') EstimatedDuration, 
               ISNULL(FinalDuration, '') FinalDuration, 
               IsPrivacy, 
               RecurringType, 
               Duration, 
               ExternalAdvisorsID, 
               RecurringGroupID, 
               Budget, 
               AlertIntervalID, 
               t.Dismissed, 
               t.workduration, 
               c.companyName, 
               curncy.CurrencyCode, 
               td.TaskDurationName
        FROM tbl_Tasks t
             JOIN tbl_currency curncy ON t.currencyid = curncy.currencyid
             LEFT JOIN tbl_companycontact c ON c.CompanyContactID = t.ExternalAdvisorsID
             LEFT JOIN tbl_taskduration td ON td.taskdurationid = t.workduration
        WHERE StartingDateTime BETWEEN ISNULL(@StartingdateFrom, StartingDateTime) AND ISNULL(@StartingdateTo, StartingDateTime)
              AND EndDateTime BETWEEN ISNULL(@endingdateFrom, EndDateTime) AND ISNULL(@endingdateTo, EndDateTime)
              AND 1 = CASE
                          WHEN @externalTaskView = 0
                               AND ExternalAdvisorsID IS NULL
                          THEN 1
                          WHEN @externalTaskView = 1
                               AND ExternalAdvisorsID IS NOT NULL
                          THEN 1
                          WHEN @externalTaskView = -1
                          THEN 1
                      END
              AND taskID = ISNULL(@taskID, taskID)
              AND (t.TaskName LIKE ISNULL('%' + @taskname + '%', t.TaskName)
                   OR t.TaskDescription LIKE ISNULL('%' + @taskname + '%', t.TaskDescription))
              AND 1 = CASE
                          WHEN @TaskStatus IS NULL
                          THEN 1
                          WHEN t.TaskStatus IN
        (
            SELECT *
            FROM dbo.SplitCSV(@TaskStatus, ',')
        )
                          THEN 1
                      END

             -- and 1=case when @mcTeamMembers is null then 1 when exists (select top 1 1 from tbl_TaskLinked  tc                                          
             -- where tc.objectid               
             --  IN                                                                       
             --(select * from dbo.[SplitCSV](@mcTeamMembers,',')) and tc.taskid = t.taskid                                          
             -- and ISNULL(tc.isMCUser,0) = 1 and tc.moduleid = 4 and ISNULL(IsExternalAdvisor,0) = 0         
             -- ) then 1 end              

             AND 1 = CASE
                         WHEN @OtherIndividualID IS NULL
                         THEN 1
                         WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_TaskLinked tc
            WHERE tc.objectid IN
            (
                SELECT *
                FROM dbo.[SplitCSV](@OtherIndividualID, ',')
            )
            AND tc.taskid = t.taskid
            AND tc.moduleid = 4
            AND ISNULL(IsExternalAdvisor, 0) = 0
        )
                         THEN 1
                     END
     AND 1 = CASE
                 WHEN @companiesID IS NULL
                 THEN 1
                 WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_TaskLinked tl
            WHERE t.taskid = tl.taskid
                  AND ISNULL(tl.isMCUser, 0) = 0
                  AND tl.moduleid = 5
                  AND ISNULL(IsExternalAdvisor, 0) = 0
                  AND objectid IN
            (
                SELECT *
                FROM dbo.[SplitCSV](@companiesID, ',')
            )
        )
                 THEN 1
             END
     AND 1 = CASE
                 WHEN @lnkDeal IS NULL
                 THEN 1
                 WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_TaskLinked tl
            WHERE t.taskid = tl.taskid
                  AND ISNULL(tl.isMCUser, 0) = 0
                  AND tl.moduleid = 6
                  AND ISNULL(IsExternalAdvisor, 0) = 0
                  AND objectid IN
            (
                SELECT *
                FROM dbo.[SplitCSV](@lnkDeal, ',')
            )
        )
                 THEN 1
             END
     AND 1 = CASE
                 WHEN @lnkFund IS NULL
                 THEN 1
                 WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_TaskLinked tl
            WHERE t.taskid = tl.taskid
                  AND ISNULL(tl.isMCUser, 0) = 0
                  AND tl.moduleid = 3
                  AND ISNULL(IsExternalAdvisor, 0) = 0
                  AND objectid IN
            (
                SELECT *
                FROM dbo.[SplitCSV](@lnkFund, ',')
            )
        )
                 THEN 1
             END
     AND 1 = CASE
                 WHEN @lnkPortfolio IS NULL
                 THEN 1
                 WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_TaskLinked tl
            WHERE t.taskid = tl.taskid
                  AND ISNULL(tl.isMCUser, 0) = 0
                  AND tl.moduleid = 7
                  AND ISNULL(IsExternalAdvisor, 0) = 0
                  AND objectid IN
            (
                SELECT *
                FROM dbo.[SplitCSV](@lnkPortfolio, ',')
            )
        )
                 THEN 1
             END
        ORDER BY EndDateTime DESC;
    END;
