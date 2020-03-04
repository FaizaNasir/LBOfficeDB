CREATE PROCEDURE [dbo].[proc_Outlook_Email_SET] @Subject        VARCHAR(MAX) = NULL, 
                                                @Body           VARCHAR(MAX) = NULL, 
                                                @HTMLBody       VARCHAR(MAX) = NULL, 
                                                @FromID         INT          = NULL, 
                                                @FromModuleID   INT          = NULL, 
                                                @Attachments    VARCHAR(MAX) = NULL, 
                                                @ReceivedTime   DATETIME     = NULL, 
                                                @CC             VARCHAR(MAX) = NULL, 
                                                @BCC            VARCHAR(MAX) = NULL, 
                                                @ConversationID VARCHAR(MAX) = NULL
AS
     DECLARE @EmailID INT= NULL;
    BEGIN
        INSERT INTO tbl_OutlookEmail
        (Subject, 
         Body, 
         HTMLBody, 
         FromID, 
         FromModuleID, 
         Attachments, 
         ReceivedTime, 
         CC, 
         BCC, 
         ConversationID
        )
        VALUES
        (@Subject, 
         @Body, 
         @HTMLBody, 
         @FromID, 
         @FromModuleID, 
         @Attachments, 
         @ReceivedTime, 
         @CC, 
         @BCC, 
         @ConversationID
        );
    END;
     SET @EmailID = @@IDENTITY;
     SELECT 'Success' AS Result, 
            @EmailID AS 'EmailID';

--END    

