CREATE FUNCTION [dbo].[F_CheckMeetingPrivacyByIndividual]
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
                  INNER JOIN tbl_MeetingAttendees MA ON M.MeetingID = MA.MeetingID
                  INNER JOIN tbl_ContactIndividual CI ON MA.AttendeeID = CI.IndividualID
             WHERE ma.AttendeeID = @CurrentUserID
                   AND MA.MeetingID = @MeetingID
         );
         RETURN ISNULL(@MeetingIDRetrun, 'Busy');
     END;
