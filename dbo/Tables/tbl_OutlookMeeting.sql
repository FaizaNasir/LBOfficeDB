CREATE TABLE [dbo].[tbl_OutlookMeeting] (
    [MeetingID]      INT            IDENTITY (1, 1) NOT NULL,
    [Subject]        VARCHAR (MAX)  NULL,
    [Body]           VARCHAR (MAX)  NULL,
    [HTMLBody]       VARCHAR (MAX)  NULL,
    [FromID]         INT            NULL,
    [FromModuleID]   INT            NULL,
    [Attachments]    VARCHAR (MAX)  NULL,
    [ReceivedTime]   DATETIME       NULL,
    [CC]             VARCHAR (MAX)  NULL,
    [BCC]            VARCHAR (MAX)  NULL,
    [ConversationID] VARCHAR (MAX)  NULL,
    [FileName]       VARCHAR (1000) NULL,
    [StartDate]      DATETIME       NULL,
    [EndDate]        DATETIME       NULL,
    CONSTRAINT [PK_tbl_OutlookMeeting] PRIMARY KEY CLUSTERED ([MeetingID] ASC)
);

