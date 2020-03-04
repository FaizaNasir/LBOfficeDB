CREATE TABLE [dbo].[tbl_PortfolioValuation] (
    [ValuationID]            INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioID]            INT             NULL,
    [VehicleID]              INT             NULL,
    [Date]                   DATETIME        NULL,
    [TypeID]                 INT             NULL,
    [MethodID]               INT             NULL,
    [ValuationLevel]         BIT             NULL,
    [InvestmentValue]        DECIMAL (18, 2) NULL,
    [Discount]               DECIMAL (18)    NULL,
    [FinalValuation]         DECIMAL (18, 2) NULL,
    [Notes]                  VARCHAR (MAX)   NULL,
    [Active]                 BIT             CONSTRAINT [DF_tbl_PortfolioValuation_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]        DATETIME        NULL,
    [ModifiedDateTime]       DATETIME        NULL,
    [CreatedBy]              VARCHAR (100)   NULL,
    [ModifiedBy]             VARCHAR (100)   NULL,
    [ForeignCurrencyAmount]  DECIMAL (18, 2) NULL,
    [CarriedSponsor]         DECIMAL (18, 6) NULL,
    [Appliedfigures]         VARCHAR (MAX)   NULL,
    [CurrentEnterpriseValue] DECIMAL (18)    NULL,
    CONSTRAINT [PK_tbl_PortfolioValuation] PRIMARY KEY CLUSTERED ([ValuationID] ASC),
    CONSTRAINT [FK_tbl_PortfolioValuation_tbl_PortfolioValuationMethod] FOREIGN KEY ([MethodID]) REFERENCES [dbo].[tbl_PortfolioValuationMethod] ([ValuationMethodID]),
    CONSTRAINT [FK_tbl_PortfolioValuation_tbl_PortfolioValuationType] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[tbl_PortfolioValuationType] ([ValuationTypeID]),
    CONSTRAINT [PortfolioValuation] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[tbl_Portfolio] ([PortfolioID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioValuation] NOCHECK CONSTRAINT [FK_tbl_PortfolioValuation_tbl_PortfolioValuationMethod];


GO
ALTER TABLE [dbo].[tbl_PortfolioValuation] NOCHECK CONSTRAINT [FK_tbl_PortfolioValuation_tbl_PortfolioValuationType];


GO
ALTER TABLE [dbo].[tbl_PortfolioValuation] NOCHECK CONSTRAINT [PortfolioValuation];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioValuation]
    ON [dbo].[tbl_PortfolioValuation]([PortfolioID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioValuation_1]
    ON [dbo].[tbl_PortfolioValuation]([MethodID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioValuation_2]
    ON [dbo].[tbl_PortfolioValuation]([TypeID] ASC);

