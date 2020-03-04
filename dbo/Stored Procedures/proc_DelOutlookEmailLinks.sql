
-- proc_getOutlookEmailLinkedTo 1,1385,4,1    

CREATE PROC [dbo].[proc_DelOutlookEmailLinks]
(@FromID         INT, 
 @FromModuleID   INT, 
 @ConversationID INT
)
AS
    BEGIN
        DELETE FROM tbl_OutlookEmail
        WHERE FromID = @FromID
              AND FromModuleID = @FromModuleID
              AND ConversationID = @ConversationID;
        SELECT 1 Result;
    END;
