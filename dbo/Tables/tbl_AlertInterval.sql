CREATE TABLE [dbo].[tbl_AlertInterval] (
    [AlertIntervalID] INT            IDENTITY (1, 1) NOT NULL,
    [IntervalDelay]   INT            NULL,
    [IntervalDesc]    VARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_alertInterval] PRIMARY KEY CLUSTERED ([AlertIntervalID] ASC)
);

