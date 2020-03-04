CREATE TABLE [dbo].[tbl_CompanyIndividuals] (
    [CompanyIndividualID]             INT           IDENTITY (1, 1) NOT NULL,
    [CompanyContactID]                INT           NULL,
    [ContactIndividualID]             INT           NULL,
    [TeamTypeName]                    VARCHAR (100) NULL,
    [isMainCompany]                   BIT           CONSTRAINT [DF_tbl_CompanyIndividuals_isMainCompany] DEFAULT ((0)) NULL,
    [isMainIndividual]                BIT           NULL,
    [ContactPositionInCompany]        VARCHAR (100) NULL,
    [ContactDepartmentInCompany]      VARCHAR (100) NULL,
    [ContactDateOfJoiningInCompany]   DATETIME      NULL,
    [ContactDateOfLeavingFromCompany] DATETIME      NULL,
    [ContactDirectLineInCompany]      VARCHAR (100) NULL,
    [ContactDirectFaxInCompany]       VARCHAR (100) NULL,
    [ContactFaxNumberInCompany]       VARCHAR (100) NULL,
    [ContactMobileNumberInCompany]    VARCHAR (100) NULL,
    [ContactEmailAddressInCompany]    VARCHAR (100) NULL,
    [ContactPrivateAssitantID]        INT           NULL,
    [ContactRole]                     VARCHAR (100) NULL,
    [OfficeID]                        INT           NULL,
    CONSTRAINT [PK_tbl_CompanyContacts] PRIMARY KEY CLUSTERED ([CompanyIndividualID] ASC),
    CONSTRAINT [FK_tbl_CompanyIndividuals_tbl_ContactIndividual] FOREIGN KEY ([ContactIndividualID]) REFERENCES [dbo].[tbl_ContactIndividual] ([IndividualID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [dbo].[tbl_CompanyIndividuals] NOCHECK CONSTRAINT [FK_tbl_CompanyIndividuals_tbl_ContactIndividual];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyIndividuals]
    ON [dbo].[tbl_CompanyIndividuals]([ContactIndividualID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyIndividuals_1]
    ON [dbo].[tbl_CompanyIndividuals]([TeamTypeName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyIndividuals_2]
    ON [dbo].[tbl_CompanyIndividuals]([CompanyIndividualID] ASC);

