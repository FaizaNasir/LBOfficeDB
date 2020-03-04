CREATE TABLE [dbo].[tbl_ErrorLog] (
    [LogID]            INT           IDENTITY (1, 1) NOT NULL,
    [Message]          VARCHAR (MAX) NULL,
    [Active]           BIT           NULL,
    [CreatedDateTime]  DATETIME      NULL,
    [ModifiedDateTime] DATETIME      NULL,
    [CreatedBy]        VARCHAR (100) NULL,
    [ModifiedBy]       VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_ErrorLog] PRIMARY KEY CLUSTERED ([LogID] ASC)
);

