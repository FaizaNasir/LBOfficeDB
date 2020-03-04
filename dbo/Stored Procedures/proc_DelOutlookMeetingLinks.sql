
-- proc_getOutlookEmailLinkedTo 1,1385,4,1    

CREATE PROC [dbo].[proc_DelOutlookMeetingLinks]
(@FromID         INT, 
 @FromModuleID   INT, 
 @ConversationID INT
)
AS
    BEGIN
        DELETE FROM tbl_OutlookMeeting
        WHERE FromModuleID = ISNULL(@FromID, FromModuleID)
              AND FromID = CASE
                               WHEN @FromModuleID = 2
                               THEN FromID
                               ELSE @FromModuleID
                           END
              AND ConversationID = @ConversationID;
        SELECT 1 Result;
    END;
