CREATE TABLE [dbo].[tbl_DealShareholdingType] (
    [DealShareholdingTypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [DealShareholdingTypeName] VARCHAR (1000) NULL,
    [CreatedDateTime]          DATETIME       NULL,
    [ModifiedDateTime]         DATETIME       NULL,
    CONSTRAINT [PK_tbl_ShareholdingType] PRIMARY KEY CLUSTERED ([DealShareholdingTypeID] ASC)
);

