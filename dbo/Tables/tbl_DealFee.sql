CREATE TABLE [dbo].[tbl_DealFee] (
    [DealFeeID]        INT             IDENTITY (1, 1) NOT NULL,
    [Percentage]       DECIMAL (18, 2) NULL,
    [AmountRaised]     INT             NULL,
    [CurrencyID]       INT             NULL,
    [Active]           BIT             NULL,
    [CreatedDateTime]  DATETIME        NULL,
    [ModifiedDateTime] DATETIME        NULL,
    [DealID]           INT             NULL,
    [IsEquity]         BIT             NULL,
    CONSTRAINT [PK_tbl_DealFee] PRIMARY KEY CLUSTERED ([DealFeeID] ASC),
    CONSTRAINT [FeeDealID] FOREIGN KEY ([DealID]) REFERENCES [dbo].[tbl_Deals] ([DealID])
);


GO
ALTER TABLE [dbo].[tbl_DealFee] NOCHECK CONSTRAINT [FeeDealID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DealFee]
    ON [dbo].[tbl_DealFee]([DealID] ASC);

