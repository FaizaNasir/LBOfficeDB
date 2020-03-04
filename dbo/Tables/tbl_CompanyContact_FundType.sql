CREATE TABLE [dbo].[tbl_CompanyContact_FundType] (
    [CompanyID]  INT NOT NULL,
    [FundTypeId] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([FundTypeId] ASC, [CompanyID] ASC)
);

