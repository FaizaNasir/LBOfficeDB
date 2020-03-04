CREATE TABLE [dbo].[tbl_InterestPortfolioDirectDeal] (
    [InterestPortfolioDirectDealID] INT           IDENTITY (1, 1) NOT NULL,
    [CompanyName]                   VARCHAR (50)  NULL,
    [SectorID]                      INT           NULL,
    [Size]                          INT           NULL,
    [CurrencyID]                    INT           NULL,
    [Side]                          VARCHAR (50)  NULL,
    [Comments]                      VARCHAR (MAX) NULL,
    [IsCompany]                     BIT           NULL,
    [ObjectID]                      INT           NULL,
    [DealDate]                      DATE          NULL,
    CONSTRAINT [PK_tbl_InterestPortfolioDirectDeal] PRIMARY KEY CLUSTERED ([InterestPortfolioDirectDealID] ASC)
);

