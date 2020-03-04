CREATE TABLE [dbo].[tbl_InvestorBankSource] (
    [InvestorBankSourcesID] INT           IDENTITY (1, 1) NOT NULL,
    [InvestorBankContactID] INT           NULL,
    [InvestorType]          VARCHAR (100) NULL,
    [InvestorBankSourceID]  INT           NULL,
    [Active]                BIT           CONSTRAINT [DF_tbl_InvestorBankSource_Active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tbl_InvestorBankSource] PRIMARY KEY CLUSTERED ([InvestorBankSourcesID] ASC)
);

