CREATE TABLE [dbo].[tbl_TaskDuration] (
    [TaskDurationID]   INT            IDENTITY (1, 1) NOT NULL,
    [TaskDurationName] VARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_TaskDuration] PRIMARY KEY CLUSTERED ([TaskDurationID] ASC)
);

