
-- created by : Syed Zain ALi          
-- [proc_Meeting_deal_committee_gets] null,null,'Deal flow weekly committee,','david',1        

CREATE PROCEDURE [dbo].[proc_Meeting_deal_committee_gets]
(@StartDate   DATETIME      = NULL, 
 @EndDate     DATETIME      = NULL, 
 @meetingType VARCHAR(1000) = NULL, 
 @userName    VARCHAR(1000) = NULL, 
 @isExcelReq  BIT           = 0
)
AS
    BEGIN
        DECLARE @currentIndividualID INT;
        SELECT @currentIndividualID = IndividualID
        FROM tbl_Individualuser
        WHERE UserName = @userName;
        IF @meetingType = ''
            SET @meetingType = NULL;
        SELECT [MeetingDate], 
               [MeetingEndDate], 
               [MeetingStartTime], 
               [MeetingEndTime], 
               [MeetingName],
               CASE
                   WHEN @isExcelReq = 1
                   THEN dbo.[F_GetMeetingAttendees](tm.[MeetingID], 4, 1)
                   ELSE ''
               END AS Attendees, 
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
               tm.LocationName, 
               AlertIntervalID, 
               Dismissed, 
               DealName, 
               DealID, 
               DealCurrentTargetID, 
               DealID AS 'PortfolioTargetTypeID', 
               d.DealTypeID
        FROM [dbo].[tbl_Meetings] tm
             JOIN tbl_MeetingLinkedTo mc ON mc.MeetingID = tm.MeetingID
                                            AND moduleid = 6
             JOIN tbl_Deals d ON d.dealid = mc.objectid
        WHERE tm.MeetingDate BETWEEN ISNULL(@StartDate, tm.MeetingDate) AND ISNULL(@EndDate, tm.MeetingDate)
              AND tm.MeetingType IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@meetingType, ',')
        )
        ORDER BY [MeetingDate] DESC;
    END;
