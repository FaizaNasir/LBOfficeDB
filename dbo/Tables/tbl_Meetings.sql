CREATE TABLE [dbo].[tbl_Meetings] (
    [MeetingID]         INT            IDENTITY (1, 1) NOT NULL,
    [MeetingName]       VARCHAR (100)  NULL,
    [isPrivate]         BIT            NULL,
    [MeetingDesc]       VARCHAR (MAX)  NULL,
    [MeetingDate]       DATETIME       NULL,
    [MeetingEndDate]    DATETIME       NULL,
    [MeetingStartTime]  TIME (7)       NULL,
    [MeetingEndTime]    TIME (7)       NULL,
    [MeetingLocationID] INT            NULL,
    [MeetingLocation]   VARCHAR (100)  NULL,
    [LastMeetingID]     INT            NULL,
    [isRecurring]       BIT            NULL,
    [RecuringFrequency] VARCHAR (100)  NULL,
    [UsersCanNotEdit]   VARCHAR (100)  NULL,
    [UserCanNotRead]    VARCHAR (100)  NULL,
    [MeetingType]       VARCHAR (50)   NULL,
    [MeetingComments]   VARCHAR (MAX)  NULL,
    [MeetingRoom]       VARCHAR (100)  NULL,
    [AlertIntervalID]   INT            NULL,
    [AlertComments]     VARCHAR (2000) NULL,
    [Duration]          INT            NULL,
    [Address]           VARCHAR (250)  NULL,
    [ZipCode]           VARCHAR (100)  NULL,
    [CityID]            INT            NULL,
    [CountryID]         INT            NULL,
    [ParentMeetingID]   INT            NULL,
    [LocationName]      VARCHAR (1000) NULL,
    [IsDocAttach]       BIT            NULL,
    [Dismissed]         BIT            NULL,
    [StateID]           INT            NULL,
    [PhNumber]          VARCHAR (100)  NULL,
    [Active]            BIT            CONSTRAINT [DF_tbl_Meetings_Active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tbl_Meetings] PRIMARY KEY CLUSTERED ([MeetingID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Meetings]
    ON [dbo].[tbl_Meetings]([MeetingName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Meetings_1]
    ON [dbo].[tbl_Meetings]([MeetingStartTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Meetings_2]
    ON [dbo].[tbl_Meetings]([ParentMeetingID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Meetings_3]
    ON [dbo].[tbl_Meetings]([MeetingType] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Meetings_4]
    ON [dbo].[tbl_Meetings]([CountryID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Meetings_5]
    ON [dbo].[tbl_Meetings]([AlertIntervalID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Meetings_6]
    ON [dbo].[tbl_Meetings]([MeetingDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Meetings_7]
    ON [dbo].[tbl_Meetings]([MeetingID] ASC);

