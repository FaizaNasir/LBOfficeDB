CREATE TABLE [dbo].[tbl_PortfolioLegal] (
    [PortfolioLegalID]             INT             IDENTITY (1, 1) NOT NULL,
    [Capital]                      DECIMAL (18, 2) NULL,
    [CapitalCurrencyID]            INT             NULL,
    [LegalStructureID]             VARCHAR (1000)  NULL,
    [LegalRepresentativeCompanyID] INT             NULL,
    [TradeRegister]                VARCHAR (50)    NULL,
    [SectorCode]                   VARCHAR (50)    NULL,
    [CurrencyID]                   INT             NULL,
    [IsQuoted]                     BIT             NULL,
    [StockExchange]                VARCHAR (50)    NULL,
    [TickerSymbol]                 VARCHAR (50)    NULL,
    [ContingentLiabilities]        VARCHAR (MAX)   NULL,
    [LegalNotes]                   VARCHAR (MAX)   NULL,
    [NumberOfShares]               INT             NULL,
    [Active]                       BIT             NULL,
    [CreatedDateTime]              DATETIME        NULL,
    [ModifiedDateTime]             DATETIME        NULL,
    [PortfolioID]                  INT             NULL,
    [CreatedBy]                    VARCHAR (100)   NULL,
    [ModifiedBy]                   VARCHAR (100)   NULL,
    CONSTRAINT [PK_tbl_PortfolioLegal_1] PRIMARY KEY CLUSTERED ([PortfolioLegalID] ASC),
    CONSTRAINT [LegalPortfolioID] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[tbl_Portfolio] ([PortfolioID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioLegal] NOCHECK CONSTRAINT [LegalPortfolioID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioLegal]
    ON [dbo].[tbl_PortfolioLegal]([PortfolioID] ASC);

