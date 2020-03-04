CREATE TABLE [dbo].[tbl_InvestorBankInvestmentTypes] (
    [InvestorBankInvestmentTypesID] INT           IDENTITY (1, 1) NOT NULL,
    [InvestorBankInvestmentTypeID]  INT           NULL,
    [InvestorType]                  VARCHAR (100) NULL,
    [InvestorBankID]                INT           NULL,
    CONSTRAINT [PK_tbl_InvestorBankInvestmentTypes] PRIMARY KEY CLUSTERED ([InvestorBankInvestmentTypesID] ASC)
);

