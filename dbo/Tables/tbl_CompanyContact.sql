CREATE TABLE [dbo].[tbl_CompanyContact] (
    [CompanyContactID]              INT             IDENTITY (1, 1) NOT NULL,
    [CompanyLogo]                   VARCHAR (MAX)   NULL,
    [ExternalAdvisorTypeID]         INT             NULL,
    [CompanyCountryID]              INT             NULL,
    [CompanyCityID]                 INT             NULL,
    [CompanyMainIndividualID]       INT             NULL,
    [CompanyStatus]                 VARCHAR (100)   NULL,
    [CompanyIndustryID]             INT             NULL,
    [CompanyBusinessAreaID]         INT             NULL,
    [CompanyBusinessDesc]           VARCHAR (5000)  NULL,
    [CompanyName]                   VARCHAR (100)   NULL,
    [CompanyWebSite]                VARCHAR (100)   NULL,
    [CompanyAddress]                VARCHAR (100)   NULL,
    [CompanyZip]                    VARCHAR (100)   NULL,
    [CompanyPOBox]                  VARCHAR (100)   NULL,
    [CompanyPhone]                  VARCHAR (100)   NULL,
    [CompanyFax]                    VARCHAR (100)   NULL,
    [CompanyCreationDate]           DATETIME        NULL,
    [CompanyCreatedDate]            DATETIME        NULL,
    [CompanyStartCollaborationDate] DATETIME        NULL,
    [CompanyActivity]               VARCHAR (100)   NULL,
    [CompanyLinkedIn]               VARCHAR (100)   NULL,
    [CompanyFacebook]               VARCHAR (100)   NULL,
    [CompanyTwitter]                VARCHAR (100)   NULL,
    [CompanyComments]               VARCHAR (5000)  NULL,
    [StateId]                       INT             NULL,
    [LinkedTo]                      INT             NULL,
    [Active]                        BIT             CONSTRAINT [DF_tbl_CompanyContact_Active] DEFAULT ((1)) NULL,
    [CompanyGeography]              VARCHAR (5000)  NULL,
    [CompanyAssetsUnderManagement]  VARCHAR (5000)  NULL,
    [CompanyNbActiveFunds]          VARCHAR (5000)  NULL,
    [CompanyNbClosedFunds]          VARCHAR (5000)  NULL,
    [CompanyNbPortfolioCompanies]   VARCHAR (5000)  NULL,
    [CompanyCurrencies]             INT             NULL,
    [LPTypeID]                      INT             NULL,
    [AccountName]                   NVARCHAR (1000) NULL,
    [CreatedBy] NVARCHAR(1000) NULL, 
    [ModifiedBy] NVARCHAR(1000) NULL, 
    CONSTRAINT [PK_tbl_CompanyContact] PRIMARY KEY CLUSTERED ([CompanyContactID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyContact]
    ON [dbo].[tbl_CompanyContact]([CompanyCountryID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyContact_1]
    ON [dbo].[tbl_CompanyContact]([CompanyName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyContact_2]
    ON [dbo].[tbl_CompanyContact]([CompanyContactID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyContact_3]
    ON [dbo].[tbl_CompanyContact]([CompanyIndustryID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyContact_4]
    ON [dbo].[tbl_CompanyContact]([CompanyCityID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyContact_5]
    ON [dbo].[tbl_CompanyContact]([CompanyBusinessAreaID] ASC);

