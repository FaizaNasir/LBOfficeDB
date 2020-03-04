CREATE PROCEDURE [dbo].[proc_Outlook_Meeting_SET] @Subject        VARCHAR(MAX)  = NULL, 
                                                  @Body           VARCHAR(MAX)  = NULL, 
                                                  @HTMLBody       VARCHAR(MAX)  = NULL, 
                                                  @FromID         INT           = NULL, 
                                                  @FromModuleID   INT           = NULL, 
                                                  @Attachments    VARCHAR(MAX)  = NULL, 
                                                  @ReceivedTime   DATETIME      = NULL, 
                                                  @CC             VARCHAR(MAX)  = NULL, 
                                                  @BCC            VARCHAR(MAX)  = NULL, 
                                                  @ConversationID VARCHAR(MAX)  = NULL, 
                                                  @fileName       VARCHAR(1000), 
                                                  @startDate      DATETIME, 
                                                  @endDate        DATETIME
AS
     DECLARE @MeetingID INT= NULL;
    BEGIN
        SET @MeetingID = 0;
        SELECT @MeetingID = ISNULL(m.MeetingID, 0)
        FROM tbl_OutlookMeeting m
        WHERE m.FromID = @FromID
              AND m.FromModuleID = @FromModuleID
              AND m.ConversationID = @ConversationID;
        IF(@MeetingID = 0)
            BEGIN
                INSERT INTO tbl_OutlookMeeting
                (Subject, 
                 Body, 
                 HTMLBody, 
                 FromID, 
                 FromModuleID, 
                 Attachments, 
                 ReceivedTime, 
                 CC, 
                 BCC, 
                 ConversationID, 
                 [FileName], 
                 startdate, 
                 enddate
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
                 @ConversationID, 
                 @FileName, 
                 @startdate, 
                 @enddate
                );
        END;
    END;
     SET @MeetingID = @@IDENTITY;
     SELECT 'Success' AS Result, 
            @MeetingID AS 'MeetingID';

--END

