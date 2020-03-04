CREATE TABLE [dbo].[tbl_companyOptionalBis] (
    [CompanyId]            INT            NOT NULL,
    [MassenaPrivateBanker] INT            NULL,
    [DepositaryBank]       INT            NULL,
    [InvestmentMode]       INT            NULL,
    [GroupName]            NVARCHAR (MAX) NULL,
    [Insurer]              INT            NULL,
    [ContractReference]    NVARCHAR (MAX) NULL,
    [Greetings1]           NVARCHAR (MAX) NULL,
    [Greetings2]           NVARCHAR (MAX) NULL,
    [Bank]                 NVARCHAR (MAX) NULL,
    [SWIFT]                NVARCHAR (MAX) NULL,
    [IBAN]                 NVARCHAR (MAX) NULL,
    [AttentionTo]          INT            NULL,
    [CountryID]            INT            NULL,
    PRIMARY KEY CLUSTERED ([CompanyId] ASC)
);

