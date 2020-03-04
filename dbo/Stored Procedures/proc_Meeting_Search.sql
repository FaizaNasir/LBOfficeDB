
--exec [dbo].[proc_Meeting_Search] @FreeText=NULL,@StartDate='2013-12-01 00:00:00',            
--@EndDate='2013-12-31 00:00:00',@meetingType=NULL,@mcIndividualID=NULL,            
--@otherIndividualID=NULL,@lnkToCompany='255,',@company=327,@lnkToDeal='32,',@deal=null,@lnkFund=NULL,            
--@userName='admin',@isExcelReq=1            
-- created by : Syed Zain ALi                        
-- [proc_Meeting_Search] null,null,null,null,null,null,'33,',null,'david',0                                                

CREATE PROCEDURE [dbo].[proc_Meeting_Search]
(@FreeText          VARCHAR(MAX)  = NULL, 
 @StartDate         DATETIME      = NULL, 
 @EndDate           DATETIME      = NULL, 
 @meetingType       VARCHAR(1000) = NULL, 
 @mcIndividualID    VARCHAR(1000) = NULL, 
 @otherIndividualID VARCHAR(1000) = NULL, 
 @lnkToCompany      VARCHAR(1000) = NULL, 
 @company           INT           = NULL, 
 @lnkToDeal         VARCHAR(1000) = NULL, 
 @deal              INT           = NULL, 
 @lnkFund           VARCHAR(1000) = NULL, 
 @lnkPortfolio      VARCHAR(1000) = NULL, 
 @userName          VARCHAR(1000) = NULL, 
 @isExcelReq        BIT           = 0, 
 @moduleID          INT
)
AS
     IF @moduleID = 2
         SET @moduleID = NULL;
     IF @startDate IS NULL
         SET @startDate = '01/01/1800';
     IF @endDate IS NULL
         SET @endDate = '01/01/2100';
    BEGIN
        DECLARE @currentIndividualID INT;
        SELECT @currentIndividualID = IndividualID
        FROM tbl_Individualuser
        WHERE UserName = @userName;
        IF @meetingType = ''
            SET @meetingType = NULL;
        IF @lnkToCompany = ''
            SET @lnkToCompany = NULL;
        IF @mcIndividualID = ''
            SET @mcIndividualID = NULL;
        IF @otherIndividualID = ''
            SET @otherIndividualID = NULL;
        IF @lnkToDeal = ''
            SET @lnkToDeal = NULL;
        IF @lnkFund = ''
            SET @lnkFund = NULL;
        IF @lnkPortfolio = ''
            SET @lnkPortfolio = NULL;
        SELECT [MeetingDate], 
               [MeetingEndDate], 
               [MeetingStartTime], 
               [MeetingEndTime], 
               [MeetingName],
               CASE
                   WHEN @isExcelReq = 1
                   THEN dbo.[F_GetMeetingAttendees](tm.[MeetingID], 5, 0)
                   ELSE ''
               END AS LinkToCompanies,
               CASE
                   WHEN @isExcelReq = 1
                   THEN dbo.[F_GetMeetingAttendees](tm.[MeetingID], 4, 0)
                   ELSE ''
               END AS Attendees,
               CASE
                   WHEN @isExcelReq = 1
                   THEN dbo.[F_GetMeetingAttendees](tm.[MeetingID], 4, 1)
                   ELSE ''
               END AS MCAttendees, 
               tm.[MeetingID], 
        (
            SELECT COUNT(1)
            FROM tbl_Meetings tm1
            WHERE tm1.ParentMeetingID = tm.MeetingID
        ) AS ChildCount, 
               [isPrivate], 
               [MeetingDesc], 
               ParentMeetingID,
               CASE
                   WHEN ISNULL(tm.isPrivate, 0) = 0
                        OR EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_MeetingLinkedTo ma
            WHERE ma.MeetingID = tm.MeetingID
                  AND ma.isMCUser = 1
                  AND ma.objectid = @currentIndividualID
                  AND ma.moduleid = 4
        )
                   THEN 0
                   WHEN tm.isPrivate = 1
                   THEN 1
               END IsConfidential, 
               [MeetingLocation], 
               [RecuringFrequency], 
               [MeetingType], 
               [MeetingComments], 
               [MeetingRoom], 
               [AlertComments], 
               [Duration], 
               [Address], 
               [ZipCode], 
               tm.[CityID], 
               tm.[CountryID], 
        (
            SELECT CountryName
            FROM dbo.tbl_Country c
            WHERE c.CountryID = tm.CountryID
        ) CountryName, 
               [CityName], 
               tm.LocationName, 
               AlertIntervalID, 
               Dismissed
        FROM [dbo].[tbl_Meetings] tm
             LEFT OUTER JOIN tbl_City ON tm.CityID = tbl_City.CityID
        WHERE(ISNULL(tm.MeetingName, '') LIKE ISNULL('%' + @FreeText + '%', ISNULL(tm.MeetingName, ''))
              OR ISNULL(tm.MeetingComments, '') LIKE ISNULL('%' + @FreeText + '%', ISNULL(tm.MeetingComments, '')))
             AND tm.MeetingDate BETWEEN ISNULL(@StartDate, tm.MeetingDate) AND ISNULL(@EndDate, tm.MeetingDate)
             AND 1 = CASE
                         WHEN @mcIndividualID IS NULL
                         THEN 1
                         WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_MeetingLinkedTo ma
            WHERE ma.MeetingID = tm.MeetingID
                  AND moduleid = 4
                  AND ISNULL(isMCUser, 0) = 1
                  AND ma.objectID IN
            (
                SELECT *
                FROM dbo.[SplitCSV](@mcIndividualID, ',')
            )
        )
                         THEN 1
                     END
             AND 1 = CASE
                         WHEN @otherIndividualID IS NULL
                         THEN 1
                         WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_MeetingLinkedTo ma
            WHERE ma.MeetingID = tm.MeetingID
                  AND moduleid = 4
                  AND ma.objectID IN
            (
                SELECT *
                FROM dbo.[SplitCSV](@otherIndividualID, ',')
            )
        )
                         THEN 1
                     END
        AND 1 = CASE
                    WHEN @meetingType IS NULL
                    THEN 1
                    WHEN tm.MeetingType IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@meetingType, ',')
        )
                    THEN 1
                END
        AND 1 = CASE
                    WHEN @lnkToCompany IS NULL
                    THEN 1
                    WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_MeetingLinkedTo mc
            WHERE mc.MeetingID = tm.MeetingID
                  AND moduleid = 5
                  AND mc.objectid IN
            (
                SELECT *
                FROM dbo.[SplitCSV](@lnkToCompany, ',')
            )
            AND mc.objectid IN
            (
                SELECT ISNULL(@company, mc.objectid)
            )
        )
                    THEN 1
                END
        AND 1 = CASE
                    WHEN @lnkToDeal IS NULL
                    THEN 1
                    WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_MeetingLinkedTo mc
            WHERE mc.MeetingID = tm.MeetingID
                  AND moduleid = 6
                  AND mc.objectid IN
            (
                SELECT *
                FROM dbo.[SplitCSV](@lnkToDeal, ',')
            )
            AND mc.objectid IN
            (
                SELECT ISNULL(@deal, mc.objectid)
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
            FROM tbl_MeetingLinkedTo mc
            WHERE mc.MeetingID = tm.MeetingID
                  AND moduleid = 3
                  AND mc.objectid IN
            (
                SELECT *
                FROM dbo.[SplitCSV](@lnkFund, ',')
            )
        )
                    THEN 1
                END
        AND tm.active = 1

        --	    UNION ALL
        --	    select distinct ISNULL(StartDate,getdate()),ISNULL(EndDate,getdate()),'1900-01-01 08:00:00.000','1900-01-01 08:00:00.000',
        --Subject,null,null,null,-1,null,null,null,null,null,null,
        --null,[FileName],null,null,null,null,null,null,null,null,null,null,null,null,null
        --	    from tbl_OutlookMeeting
        --	    where FromID = ISNULL(null,FromID)
        --and 1 = case when @moduleID = 4 and FromModuleID in (
        --                 SELECT *
        --                 FROM dbo.[SplitCSV](@otherIndividualID, ',')
        --             ) then 1 when  @moduleID = 5 and FromModuleID in (
        --                 SELECT *
        --                 FROM dbo.[SplitCSV](@lnkToCompany, ',')
        --             )then 1 when  @moduleID = 6 and FromModuleID in (
        --                 SELECT *
        --                 FROM dbo.[SplitCSV](@lnkToDeal, ',')
        --             )then 1 when ISNULL(@moduleID,2) = 2 then 1 end  
        --		   and StartDate BETWEEN ISNULL(@StartDate, StartDate) AND ISNULL(@EndDate, StartDate)  

        ORDER BY [MeetingDate] DESC;
    END;
