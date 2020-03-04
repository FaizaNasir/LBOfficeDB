CREATE PROC [dbo].[DeleteMeeting](@meetingID INT)
AS
    BEGIN
        DELETE FROM tbl_MeetingLinkedTo
        WHERE MeetingID = @meetingID;
        DELETE FROM tbl_Meetings
        WHERE MeetingID = @meetingID;
        SELECT 1 Result, 
               '' Msg;
    END;
