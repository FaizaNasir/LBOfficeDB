CREATE PROCEDURE [dbo].[proc_MeetingDetailsByDate_GET] --null,20
@MeetingDate VARCHAR(1000) = NULL
AS
    BEGIN
        SELECT *
        FROM tbl_Meetings M
             INNER JOIN tbl_MeetingRecurranceDetails MD ON M.MeetingID = MD.MeetingId
        WHERE MD.MeetingDate = CONVERT(DATETIME, @MeetingDate);
    END;
