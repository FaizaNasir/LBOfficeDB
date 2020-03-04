CREATE TABLE [dbo].[tbl_InvestorTypeDetail] (
    [InvestorTypeDetailID] INT IDENTITY (1, 1) NOT NULL,
    [InvestorTypeID]       INT NULL,
    [ObjectTypeID]         INT NULL,
    [IsCompany]            BIT NULL,
    [IsIndividual]         BIT NULL,
    CONSTRAINT [PK_tbl_InvestorTypeDetail] PRIMARY KEY CLUSTERED ([InvestorTypeDetailID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_InvestorTypeDetail]
    ON [dbo].[tbl_InvestorTypeDetail]([ObjectTypeID] ASC);

