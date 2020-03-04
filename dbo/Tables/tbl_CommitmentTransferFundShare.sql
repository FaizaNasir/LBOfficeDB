CREATE TABLE [dbo].[tbl_CommitmentTransferFundShare] (
    [CommitmentTransferShareID] INT              IDENTITY (1, 1) NOT NULL,
    [CommitmentTransferID]      INT              NULL,
    [FundShareID]               INT              NULL,
    [ShareAmount]               NUMERIC (25, 15) NULL,
    [AmountPer]                 NUMERIC (25, 15) NULL,
    [ToShareID]                 INT              NULL,
    CONSTRAINT [PK_tbl_CommitmentTransferFundShare] PRIMARY KEY CLUSTERED ([CommitmentTransferShareID] ASC)
);

