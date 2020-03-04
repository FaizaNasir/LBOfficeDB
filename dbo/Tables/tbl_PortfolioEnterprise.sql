CREATE TABLE [dbo].[tbl_PortfolioEnterprise] (
    [PortfolioEnterpriseID] INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioID]           INT             NULL,
    [Date]                  DATETIME        NULL,
    [CurrencyCode]          VARCHAR (100)   NULL,
    [EnterpriseValue]       DECIMAL (18, 2) NULL,
    [NetFinancialDebt]      DECIMAL (18, 2) NULL,
    [EquityValue]           DECIMAL (18, 2) NULL,
    [Notes]                 VARCHAR (MAX)   NULL,
    [Active]                BIT             NULL,
    [CreatedDateTime]       DATETIME        NULL,
    [ModifiedDateTime]      DATETIME        NULL,
    [CreatedBy]             VARCHAR (100)   NULL,
    [ModifiedBy]            VARCHAR (100)   NULL,
    [EnterpriseValueEur]    DECIMAL (18, 2) NULL,
    [NetFinancialDebtEur]   DECIMAL (18, 2) NULL,
    [EquityValueEur]        DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_tbl_PortfolioEnterprise] PRIMARY KEY CLUSTERED ([PortfolioEnterpriseID] ASC)
);

