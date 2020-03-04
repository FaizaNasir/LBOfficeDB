CREATE TABLE [dbo].[tbl_DealFundInvestorStatus] (
    [DealFundInvestorStatusID]   INT            IDENTITY (1, 1) NOT NULL,
    [DealFundInvestorStatusName] VARCHAR (1000) NULL,
    [ActivityID]                 INT            NULL,
    [CreatedDateTime]            DATETIME       NULL,
    [ModifiedDateTime]           DATETIME       NULL,
    [Active]                     BIT            NULL,
    CONSTRAINT [PK_tbl_DealFundInvestorStatus] PRIMARY KEY CLUSTERED ([DealFundInvestorStatusID] ASC)
);

