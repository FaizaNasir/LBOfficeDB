CREATE TABLE [dbo].[tbl_TeamType] (
    [TeamTypeID]      INT           NOT NULL,
    [TeamTypeTitle]   VARCHAR (100) NULL,
    [TeamTypeDesc]    VARCHAR (100) NULL,
    [Active]          BIT           NULL,
    [CreatedDateTime] DATETIME      NULL,
    CONSTRAINT [PK_tbl_TeamType] PRIMARY KEY CLUSTERED ([TeamTypeID] ASC)
);

