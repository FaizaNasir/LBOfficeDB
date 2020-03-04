CREATE TABLE [dbo].[tbl_DealFundNegativeInvestor] (
    [DealFundNegativeInvestorID] INT           IDENTITY (1, 1) NOT NULL,
    [DealID]                     INT           NULL,
    [CompanyContactID]           INT           NULL,
    [CreatedDateTime]            DATETIME      NULL,
    [ModifiedDateTime]           DATETIME      NULL,
    [Active]                     BIT           NULL,
    [CreatedBy]                  VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_DealFundNegetiveInvestor] PRIMARY KEY CLUSTERED ([DealFundNegativeInvestorID] ASC),
    CONSTRAINT [DealFundNegativeInvestorDealID] FOREIGN KEY ([DealID]) REFERENCES [dbo].[tbl_Deals] ([DealID])
);


GO
ALTER TABLE [dbo].[tbl_DealFundNegativeInvestor] NOCHECK CONSTRAINT [DealFundNegativeInvestorDealID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DealFundNegativeInvestor]
    ON [dbo].[tbl_DealFundNegativeInvestor]([DealID] ASC);

