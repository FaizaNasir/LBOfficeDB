CREATE TABLE [dbo].[tbl_OutlookEmail] (
    [EmailID]        INT           IDENTITY (1, 1) NOT NULL,
    [Subject]        VARCHAR (MAX) NULL,
    [Body]           VARCHAR (MAX) NULL,
    [HTMLBody]       VARCHAR (MAX) NULL,
    [FromID]         INT           NULL,
    [FromModuleID]   INT           NULL,
    [Attachments]    VARCHAR (MAX) NULL,
    [ReceivedTime]   DATETIME      NULL,
    [CC]             VARCHAR (MAX) NULL,
    [BCC]            VARCHAR (MAX) NULL,
    [ConversationID] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tbl_OutlookEmail] PRIMARY KEY CLUSTERED ([EmailID] ASC)
);

