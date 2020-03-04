CREATE TABLE [dbo].[tbl_DealFundInvestors] (
    [DealFundInvestorID]       INT              IDENTITY (1, 1) NOT NULL,
    [DealID]                   INT              NULL,
    [CompanyContactID]         INT              NULL,
    [InvestorTypeID]           INT              NULL,
    [DealCompanyMainContactID] INT              NULL,
    [ForecastedAmount]         DECIMAL (25, 10) NULL,
    [ClosedAmount]             DECIMAL (25, 10) NULL,
    [DealFundInvestorStatusID] INT              NULL,
    [DealFundInvestorNotes]    VARCHAR (1000)   NULL,
    [IsIndividual]             BIT              NULL,
    [FundID]                   INT              NULL,
    [CreatedDateTime]          DATETIME         NULL,
    [ModifiedDateTime]         DATETIME         NULL,
    [Active]                   BIT              NULL,
    [CreatedBy]                VARCHAR (100)    NULL,
    [ModifiedBy]               VARCHAR (100)    NULL,
    CONSTRAINT [PK_tbl_DealInvestor] PRIMARY KEY CLUSTERED ([DealFundInvestorID] ASC),
    CONSTRAINT [DealFundInvestorsDealID] FOREIGN KEY ([DealID]) REFERENCES [dbo].[tbl_Deals] ([DealID])
);


GO
ALTER TABLE [dbo].[tbl_DealFundInvestors] NOCHECK CONSTRAINT [DealFundInvestorsDealID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DealFundInvestors]
    ON [dbo].[tbl_DealFundInvestors]([DealID] ASC);

