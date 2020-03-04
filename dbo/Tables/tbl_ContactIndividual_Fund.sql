CREATE TABLE [dbo].[tbl_ContactIndividual_Fund] (
    [ContactIndividual_FundId] INT            IDENTITY (1, 1) NOT NULL,
    [ContactIndividualId]      INT            NOT NULL,
    [VehicleId]                INT            NOT NULL,
    [Bank]                     NVARCHAR (MAX) NULL,
    [SWIFT]                    NVARCHAR (MAX) NULL,
    [IBAN]                     NVARCHAR (MAX) NULL,
    [InvestmentMode]           INT            NULL,
    CONSTRAINT [PK_tbl_ContactIndividual_Fund] PRIMARY KEY CLUSTERED ([ContactIndividual_FundId] ASC)
);

