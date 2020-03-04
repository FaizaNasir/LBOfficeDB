CREATE TABLE [dbo].[tbl_MeetingLinkedTo] (
    [MeetingLinkedToID] INT IDENTITY (1, 1) NOT NULL,
    [MeetingID]         INT NULL,
    [ModuleID]          INT NULL,
    [ObjectID]          INT NULL,
    [isMCUser]          BIT NULL,
    CONSTRAINT [PK_tbl_MeetingLinkedTo] PRIMARY KEY CLUSTERED ([MeetingLinkedToID] ASC)
);

