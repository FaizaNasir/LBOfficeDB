CREATE TABLE [dbo].[tbl_CompanyOptionalBis_EconomicBeneficiaries] (
    [CompanyId] INT NOT NULL,
    [ContactId] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([CompanyId] ASC, [ContactId] ASC),
    CONSTRAINT [[FK_tbl_companyOptionalBis_tbl_companyOptionalBisEconomicBeneficiaries]]] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[tbl_companyOptionalBis] ([CompanyId])
);

