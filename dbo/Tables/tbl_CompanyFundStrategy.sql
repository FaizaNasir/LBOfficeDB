CREATE TABLE [dbo].[tbl_CompanyFundStrategy] (
    [CompanyFundStrategyID] INT           NOT NULL,
    [Label]                 NVARCHAR (50) NOT NULL,
    [Order]                 INT           NULL,
    PRIMARY KEY CLUSTERED ([CompanyFundStrategyID] ASC)
);

