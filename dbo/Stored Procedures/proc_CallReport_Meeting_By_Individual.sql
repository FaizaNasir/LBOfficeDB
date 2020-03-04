--[proc_Test_Meeting_By_Individual] null,null,null,731

CREATE PROCEDURE [dbo].[proc_CallReport_Meeting_By_Individual]
(@StartDate         DATETIME      = NULL, 
 @EndDate           DATETIME      = NULL,                                                                          
 --@meetingType varchar(1000) = null,                              
 @mcIndividualID    VARCHAR(1000) = NULL, 
 @otherIndividualID VARCHAR(1000) = NULL
)
AS
     IF @startDate IS NULL
         SET @startDate = '01/01/1800';
     IF @endDate IS NULL
         SET @endDate = '01/01/2100';
     IF @mcIndividualID = '-1'
         SET @mcIndividualID = NULL;
     IF @otherIndividualID = ''
         SET @otherIndividualID = NULL;
    BEGIN
        SELECT DISTINCT 
               tm.MeetingDate AS startdate, 
               tm.[MeetingName], 
               tm.[MeetingID], 
               tm.MeetingType, 
               tm.MeetingComments, 
               tm.MeetingLocation, 
               tm.MeetingRoom, 
               tm.Address, 
               tm.ZipCode, 
        (
            SELECT CountryName
            FROM dbo.tbl_Country c
            WHERE c.CountryID = tm.CountryID
        ) CountryName, 
               [CityName], 
               REPLACE(dbo.F_GetMeetingMCMembers_OtherContact(tm.MeetingID, 4, NULL, 1), ',', ',') AS 'MC team members', 
               REPLACE(dbo.F_GetMeetingMCMembers_OtherContact(tm.MeetingID, 4, NULL, 0), ',', ',') AS 'Other members'
    --,ma.ObjectID                                                    
        FROM [dbo].[tbl_Meetings] tm
             LEFT OUTER JOIN tbl_MeetingLinkedTo ma ON ma.MeetingID = tm.MeetingID
                                                       AND ma.isMCUser = 1
                                                       AND ma.ModuleID = 4
             LEFT OUTER JOIN tbl_MeetingLinkedTo oima ON oima.MeetingID = tm.MeetingID
                                                         AND oima.ModuleID = 4
             LEFT OUTER JOIN tbl_City ON tm.CityID = tbl_City.CityID
        WHERE tm.MeetingDate BETWEEN ISNULL(@StartDate, tm.MeetingDate) AND ISNULL(@EndDate, tm.MeetingDate)

              --and 1 = case when @meetingType is null then 1 when tm.MeetingType IN (select * from dbo.[SplitCSV](@meetingType,',')) then 1 end                                                                          

              AND 1 = CASE
                          WHEN @mcIndividualID IS NULL
                          THEN 1
                          WHEN ma.objectID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@mcIndividualID, ',')
        )
                          THEN 1
                      END
             AND 1 = CASE
                         WHEN @otherIndividualID IS NULL
                         THEN 1
                         WHEN oima.objectID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@otherIndividualID, ',')
        )
                         THEN 1
                     END
    AND tm.active = 1
        ORDER BY [MeetingDate] DESC;
    END;
