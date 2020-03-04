
-- created date : syed zain ali  
-- [proc_Meeting_GET] 17   

CREATE PROCEDURE [dbo].[proc_Meeting_GET] @MeetingID       INT          = NULL, 
                                          @MeetingName     VARCHAR(MAX) = NULL, 
                                          @LocationName    VARCHAR(MAX) = NULL, 
                                          @ParentMeetingID INT          = NULL
AS
    BEGIN
        SELECT [MeetingID], 
               [MeetingName], 
               [isPrivate], 
               [MeetingDesc], 
               [MeetingDate], 
               [MeetingEndDate], 
               [MeetingStartTime], 
               [MeetingEndTime], 
               [MeetingLocationID], 
               [MeetingLocation], 
               [LastMeetingID], 
               [isRecurring], 
               [RecuringFrequency], 
               [UsersCanNotEdit], 
               [UserCanNotRead], 
               [MeetingType], 
               [MeetingComments], 
               [MeetingRoom], 
               [AlertComments], 
               ai.AlertIntervalID, 
               [Duration], 
               [Address], 
               [ZipCode], 
               [tbl_City].[CityID], 
               [tbl_City].[CityName], 
               tbl_Meetings.[CountryID], 
               tbl_Meetings.parentmeetingid, 
               tbl_Meetings.locationName, 
               tbl_Meetings.isdocattach, 
               Dismissed, 
               s.StateID, 
               StateTitle, 
               PhNumber, 
               IntervalDesc, 
               CountryName
        FROM [dbo].[tbl_Meetings]
             LEFT OUTER JOIN tbl_City ON tbl_Meetings.CityID = tbl_City.CityID
             LEFT JOIN tbl_state s ON s.stateid = tbl_Meetings.StateID
             LEFT JOIN tbl_alertinterval ai ON ai.AlertIntervalID = tbl_Meetings.AlertIntervalID
             LEFT JOIN tbl_country c ON c.countryid = tbl_Meetings.countryid
        WHERE MeetingID = ISNULL(@MeetingID, MeetingID)
              AND (ISNULL(MeetingName, '') = ISNULL(@MeetingName, ISNULL(MeetingName, ''))
                   OR ISNULL(MeetingComments, '') = ISNULL(@MeetingName, ISNULL(MeetingComments, '')))
              AND ISNULL(ParentMeetingID, 0) = ISNULL(@ParentMeetingID, ISNULL(ParentMeetingID, 0))
              AND ISNULL(LocationName, 0) = ISNULL(@LocationName, ISNULL(LocationName, 0));
    END;
