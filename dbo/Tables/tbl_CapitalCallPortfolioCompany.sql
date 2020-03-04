CREATE TABLE [dbo].[tbl_CapitalCallPortfolioCompany] (
    [CapitalCallPortfolioCompanyID] INT          IDENTITY (1, 1) NOT NULL,
    [CapitalCallID]                 INT          NULL,
    [CompanyContactID]              INT          NULL,
    [Active]                        BIT          NULL,
    [CreatedBy]                     VARCHAR (50) NULL,
    [CreatedDateTime]               DATETIME     NULL,
    [ModifiedBy]                    VARCHAR (50) NULL,
    [ModifiedDateTime]              DATETIME     NULL,
    CONSTRAINT [PK_tbl_CapitalCallPortfolioCompany] PRIMARY KEY CLUSTERED ([CapitalCallPortfolioCompanyID] ASC)
);

