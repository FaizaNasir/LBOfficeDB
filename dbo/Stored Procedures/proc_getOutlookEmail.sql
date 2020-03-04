
-- proc_getOutlookEmail 731,4          

CREATE PROC [dbo].[proc_getOutlookEmail]
(@objectID INT, 
 @moduleID INT
)
AS
     IF @moduleID = 2
         SET @moduleID = NULL;
     IF @objectID IS NULL
         SET @objectID = NULL;
    BEGIN
        SELECT EmailID, 
               Subject, 
               Body, 
               HTMLBody, 
               FromID, 
               FromModuleID, 
               '' AS 'IndividualFullName', 
               ConversationID, 
               Attachments, 
               ReceivedTime, 
               CC, 
               BCC
        FROM tbl_OutlookEmail e
        WHERE e.FromModuleID = ISNULL(@objectID, e.FromModuleID)
              AND e.FromID = ISNULL(@moduleID, e.FromID);
    END;
