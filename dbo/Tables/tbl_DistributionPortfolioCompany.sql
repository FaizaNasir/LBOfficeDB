CREATE TABLE [dbo].[tbl_DistributionPortfolioCompany] (
    [DistributionPortfolioCompanyID] INT          IDENTITY (1, 1) NOT NULL,
    [DistributionID]                 INT          NULL,
    [CompanyContactID]               INT          NULL,
    [Active]                         BIT          NULL,
    [CreatedBy]                      VARCHAR (50) NULL,
    [CreatedDateTime]                DATETIME     NULL,
    [ModifiedBy]                     VARCHAR (50) NULL,
    [ModifiedDateTime]               DATETIME     NULL,
    CONSTRAINT [PK_tbl_DistributionPortfolioCompany] PRIMARY KEY CLUSTERED ([DistributionPortfolioCompanyID] ASC)
);

