CREATE TABLE [dbo].[tbl_BusinessArea] (
    [BusinessAreaID]      INT           NOT NULL,
    [BusinessAreaTitle]   VARCHAR (100) NULL,
    [BusinessAreaDesc]    VARCHAR (100) NULL,
    [Active]              BIT           NULL,
    [CreatedDateTime]     DATETIME      NULL,
    [BusinessAreaTitleFr] VARCHAR (500) NULL,
    CONSTRAINT [PK_tbl_FundBusinessArea] PRIMARY KEY CLUSTERED ([BusinessAreaID] ASC)
);

