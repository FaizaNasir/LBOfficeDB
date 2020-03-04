CREATE TABLE [dbo].[tbl_DealSource] (
    [ProjectSourceID]    INT           IDENTITY (1, 1) NOT NULL,
    [ProjectSourceTitle] VARCHAR (100) NULL,
    [ProjectSourceDesc]  VARCHAR (100) NULL,
    [Active]             BIT           NULL,
    [CreatedDatetime]    DATETIME      NULL,
    CONSTRAINT [PK_tbl_ProjectSource] PRIMARY KEY CLUSTERED ([ProjectSourceID] ASC)
);

