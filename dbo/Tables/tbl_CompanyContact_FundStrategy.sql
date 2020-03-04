CREATE TABLE [dbo].[tbl_CompanyContact_FundStrategy] (
    [CompanyId]      INT NOT NULL,
    [FundStrategyId] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([FundStrategyId] ASC, [CompanyId] ASC)
);

