CREATE FUNCTION [dbo].[F_CheckMeetingPrivacyByCompany]
(@MeetingID     INT, 
 @CurrentUserID INT
)
RETURNS VARCHAR(50)
AS
     BEGIN
         DECLARE @MeetingIDRetrun VARCHAR(50);
         SELECT @MeetingIDRetrun =
         (
             SELECT m.MeetingName
             FROM [dbo].[tbl_Meetings] M
                  INNER JOIN tbl_MeetingAttendees ON M.MeetingID = tbl_MeetingAttendees.MeetingID
             WHERE tbl_MeetingAttendees.MeetingID = @MeetingID
                   AND tbl_MeetingAttendees.AttendeeID = @CurrentUserID
         );
         RETURN ISNULL(@MeetingIDRetrun, 'Busy');
     END;
