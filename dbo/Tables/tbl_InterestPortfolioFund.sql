CREATE TABLE [dbo].[tbl_InterestPortfolioFund] (
    [InterestPortfolioFundID] INT           IDENTITY (1, 1) NOT NULL,
    [FundName]                VARCHAR (50)  NULL,
    [TypeID]                  INT           NULL,
    [Size]                    INT           NULL,
    [CurrencyID]              INT           NULL,
    [TransactionName]         VARCHAR (50)  NULL,
    [Comments]                VARCHAR (MAX) NULL,
    [IsCompany]               BIT           NULL,
    [ObjectID]                INT           NULL,
    [DealDate]                DATE          NULL,
    CONSTRAINT [PK_tbl_InterestPortfolioFundID] PRIMARY KEY CLUSTERED ([InterestPortfolioFundID] ASC)
);

