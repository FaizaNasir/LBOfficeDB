CREATE TABLE [dbo].[tbl_FundTypes] (
    [FundTypeID]          INT           NOT NULL,
    [FundTypeName]        VARCHAR (100) NULL,
    [FundTypeDescription] VARCHAR (100) NULL,
    [Active]              BIT           NULL,
    [CreatedDateTim]      DATETIME      NULL,
    CONSTRAINT [PK_tbl_FundTypes] PRIMARY KEY CLUSTERED ([FundTypeID] ASC)
);

