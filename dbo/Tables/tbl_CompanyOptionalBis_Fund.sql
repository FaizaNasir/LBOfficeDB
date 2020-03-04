CREATE TABLE [dbo].[tbl_CompanyOptionalBis_Fund] (
    [CompanyId]                 INT            NOT NULL,
    [VehicleId]                 INT            NOT NULL,
    [InvestmentMode]            INT            NULL,
    [SWIFT]                     NVARCHAR (MAX) NULL,
    [Bank]                      NVARCHAR (MAX) NULL,
    [IBAN]                      NVARCHAR (MAX) NULL,
    [CompanyOptionalBis_FundId] INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tbl_CompanyOptionalBis_Fund] PRIMARY KEY CLUSTERED ([CompanyOptionalBis_FundId] ASC)
);

