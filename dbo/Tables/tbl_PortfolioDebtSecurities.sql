CREATE TABLE [dbo].[tbl_PortfolioDebtSecurities] (
    [DebtID]               INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioSecurityID]  INT             NULL,
    [Rate]                 DECIMAL (18, 2) NULL,
    [SubscriptionDate]     DATETIME        NULL,
    [MaturityDate]         DATETIME        NULL,
    [CapitalizationDate]   DATETIME        NULL,
    [AnnualBasis]          DECIMAL (18, 6) NULL,
    [NonConversionPremium] DECIMAL (18, 6) NULL,
    [Active]               BIT             NULL,
    [CreatedDateTime]      DATETIME        NULL,
    [ModifiedDateTime]     DATETIME        NULL,
    [CreatedBy]            VARCHAR (100)   NULL,
    [ModifiedBy]           VARCHAR (100)   NULL,
    CONSTRAINT [PK_tbl_PortfolioDebtSecurities] PRIMARY KEY CLUSTERED ([DebtID] ASC)
);

