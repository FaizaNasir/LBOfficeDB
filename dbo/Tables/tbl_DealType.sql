CREATE TABLE [dbo].[tbl_DealType] (
    [ProjectTypeID]      INT           IDENTITY (1, 1) NOT NULL,
    [ProjectTypeTitle]   VARCHAR (100) NULL,
    [ProjectTypeDesc]    VARCHAR (100) NULL,
    [Active]             BIT           NULL,
    [CreatedDateTime]    DATETIME      NULL,
    [ProjectTypeTitleFr] VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_ProjectType] PRIMARY KEY CLUSTERED ([ProjectTypeID] ASC)
);

