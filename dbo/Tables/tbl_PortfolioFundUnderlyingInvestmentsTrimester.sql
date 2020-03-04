CREATE TABLE [dbo].[tbl_PortfolioFundUnderlyingInvestmentsTrimester] (
    [PortfolioFundUnderlyingInvestmentsTrimesterID] INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioFundUnderlyingInvestmentsID]          INT             NOT NULL,
    [Date]                                          DATETIME        NULL,
    [Invested]                                      DECIMAL (18, 2) NULL,
    [Proceeds]                                      DECIMAL (18, 2) NULL,
    [NAV]                                           DECIMAL (18, 2) NULL,
    [Multiple]                                      DECIMAL (18, 2) NULL,
    [Owned]                                         DECIMAL (18, 2) NULL,
    [IRR]                                           DECIMAL (18, 2) NULL,
    [RemainingCommitment]                           DECIMAL (18, 2) NULL,
    PRIMARY KEY CLUSTERED ([PortfolioFundUnderlyingInvestmentsTrimesterID] ASC),
    CONSTRAINT [FK_tbl_PortfolioFundUnderlyingInvestmentsTrimester_lbl_PortfolioFundUnderlyingInvestments] FOREIGN KEY ([PortfolioFundUnderlyingInvestmentsID]) REFERENCES [dbo].[tbl_PortfolioFundUnderlyingInvestments] ([PortfolioFundUnderlyingInvestmentsID])
);

