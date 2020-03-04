
-- proc_getOutlookEmailLinkedTo 1,1385,4,1    

CREATE PROC [dbo].[proc_DelOutlookMeeting](@MeetingID INT)
AS
    BEGIN
        DELETE FROM tbl_OutlookMeeting
        WHERE MeetingID = @MeetingID;
        SELECT 1 Result;
    END;
