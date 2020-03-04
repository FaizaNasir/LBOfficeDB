CREATE TABLE [dbo].[tbl_DealSourceType] (
    [DealSourceTypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [DealSourceTypeName] VARCHAR (1000) NULL,
    [CreatedDateTime]    DATETIME       NULL,
    [ModifiedDateTime]   DATETIME       NULL,
    CONSTRAINT [PK_tbl_DealSourceType] PRIMARY KEY CLUSTERED ([DealSourceTypeID] ASC)
);

