--[proc_Test_Meeting_By_Company] null,null,null,245

CREATE PROCEDURE [dbo].[proc_CallReport_Meeting_By_Company]
(@StartDate      DATETIME      = NULL, 
 @EndDate        DATETIME      = NULL, 
 @mcIndividualID VARCHAR(1000) = NULL, 
 @lnkToCompany   VARCHAR(1000) = NULL
)
AS
     IF @startDate IS NULL
         SET @startDate = '01/01/1800';
     IF @endDate IS NULL
         SET @endDate = '01/01/2100';
     IF @mcIndividualID = '-1'
         SET @mcIndividualID = NULL;
     IF @lnkToCompany = ''
         SET @lnkToCompany = NULL;
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
             LEFT OUTER JOIN tbl_City ON tm.CityID = tbl_City.CityID
             LEFT OUTER JOIN tbl_MeetingLinkedTo mc ON mc.MeetingID = tm.MeetingID
                                                       AND mc.moduleid = 5
        WHERE tm.MeetingDate BETWEEN ISNULL(@StartDate, tm.MeetingDate) AND ISNULL(@EndDate, tm.MeetingDate)
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
                         WHEN @lnkToCompany IS NULL
                         THEN 1
                         WHEN mc.objectid IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@lnkToCompany, ',')
        )
                         THEN 1
                     END
    AND tm.active = 1
        ORDER BY [MeetingDate] DESC;
    END;
