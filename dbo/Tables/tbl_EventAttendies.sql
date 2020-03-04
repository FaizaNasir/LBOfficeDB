CREATE TABLE [dbo].[tbl_EventAttendies] (
    [EventAttendiesID] INT IDENTITY (1, 1) NOT NULL,
    [EventID]          INT NULL,
    [ContactID]        INT NULL,
    CONSTRAINT [PK_tbl_EventAttendies] PRIMARY KEY CLUSTERED ([EventAttendiesID] ASC)
);

