CREATE TABLE [dbo].[tbl_InvestorType] (
    [InvestorTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [InvestorDesc]   VARCHAR (50) NULL,
    [IsCompany]      BIT          NULL,
    [IsIndividual]   BIT          NULL,
    CONSTRAINT [PK_tbl_InvestorType] PRIMARY KEY CLUSTERED ([InvestorTypeID] ASC)
);

