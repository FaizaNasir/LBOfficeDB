CREATE TABLE [dbo].[tbl_MeetingType] (
    [MeetingTypeID]          INT           IDENTITY (1, 1) NOT NULL,
    [MeetingTypeName]        VARCHAR (100) NULL,
    [MeetingTypeDescription] VARCHAR (100) NULL,
    [Active]                 BIT           NULL,
    [CreatedDateTime]        DATETIME      NULL,
    [CreatedBy]              VARCHAR (50)  NULL,
    [ModifiedDateTime]       DATETIME      NULL,
    [ModifiedBy]             VARCHAR (50)  NULL,
    [OrderType]              INT           NULL,
    CONSTRAINT [PK_tbl_MeetingType] PRIMARY KEY CLUSTERED ([MeetingTypeID] ASC)
);

