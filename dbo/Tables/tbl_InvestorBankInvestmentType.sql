CREATE TABLE [dbo].[tbl_InvestorBankInvestmentType] (
    [InvestorBankInvestmentTypesID]   INT            IDENTITY (1, 1) NOT NULL,
    [InvestorBankInvestmentTypeTitle] VARCHAR (100)  NULL,
    [InvestorBankInvestmentTypeDesc]  VARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_InvestorBankInvestmentType] PRIMARY KEY CLUSTERED ([InvestorBankInvestmentTypesID] ASC)
);

