CREATE TABLE [dbo].[tbl_DealOwnership] (
    [DealOwnershipID]   INT            IDENTITY (1, 1) NOT NULL,
    [DealOwnershipName] VARCHAR (1000) NULL,
    [CreatedDateTime]   DATETIME       NULL,
    [ModifiedDateTime]  DATETIME       NULL,
    CONSTRAINT [PK_tbl_DealOwnership] PRIMARY KEY CLUSTERED ([DealOwnershipID] ASC)
);

