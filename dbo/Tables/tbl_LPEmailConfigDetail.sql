CREATE TABLE [dbo].[tbl_LPEmailConfigDetail] (
    [LPEmailConfigDetailID] INT           IDENTITY (1, 1) NOT NULL,
    [LPEmailConfigID]       INT           NULL,
    [ContactID]             INT           NULL,
    [IsCC]                  BIT           NULL,
    [Active]                BIT           NULL,
    [CreatedDate]           DATETIME      NULL,
    [ModifiedDate]          DATETIME      NULL,
    [CreatedBy]             VARCHAR (100) NULL,
    [ModifiedBy]            VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_LPEmailConfigDetail] PRIMARY KEY CLUSTERED ([LPEmailConfigDetailID] ASC)
);

