CREATE TABLE [dbo].[tbl_ContactIndividual] (
    [IndividualID]          INT             IDENTITY (1, 1) NOT NULL,
    [IndividualCountryID]   INT             NULL,
    [IndividualCityID]      INT             NULL,
    [IndividualTitle]       VARCHAR (100)   NULL,
    [IndividualFirstName]   VARCHAR (100)   NULL,
    [IndividualMiddleName]  VARCHAR (100)   NULL,
    [IndividualLastName]    VARCHAR (100)   NULL,
    [IndividualFullName]    VARCHAR (1000)  NULL,
    [IndividualDOB]         DATETIME        NULL,
    [IndividualPhone]       VARCHAR (100)   NULL,
    [IndividualMobile]      VARCHAR (100)   NULL,
    [IndividualFax]         VARCHAR (100)   NULL,
    [IndividualEmail]       VARCHAR (100)   NULL,
    [IndividualAddress]     VARCHAR (100)   NULL,
    [IndividualZipCode]     VARCHAR (100)   NULL,
    [IndividualPOBox]       VARCHAR (100)   NULL,
    [IndividualPhoto]       VARCHAR (MAX)   NULL,
    [IndividualBackground]  VARCHAR (100)   NULL,
    [IndividualComments]    VARCHAR (5000)  NULL,
    [IndividualKnowledgeID] INT             NULL,
    [IndividualFacebookID]  VARCHAR (100)   NULL,
    [IndividualLinkedInID]  VARCHAR (100)   NULL,
    [IndividualSkypeID]     VARCHAR (100)   NULL,
    [IndividualTwitterID]   VARCHAR (100)   NULL,
    [IndividualOtherSNIDs]  VARCHAR (100)   NULL,
    [IndividualExpertIn]    VARCHAR (100)   NULL,
    [StateId]               INT             NULL,
    [LinkedTo]              INT             NULL,
    [Active]                BIT             CONSTRAINT [DF_tbl_ContactIndividual_Active] DEFAULT ((1)) NULL,
    [Office]                VARCHAR (5000)  NULL,
    [LanguageID]            VARCHAR (200)   NULL,
    [CreatedDate]           DATETIME        NULL,
    [UpdatedDate]           DATETIME        NULL,
    [LPTypeID]              INT             NULL,
    [AccountName]           NVARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_Contacts_1] PRIMARY KEY CLUSTERED ([IndividualID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ContactIndividual]
    ON [dbo].[tbl_ContactIndividual]([IndividualLastName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ContactIndividual_1]
    ON [dbo].[tbl_ContactIndividual]([IndividualFirstName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ContactIndividual_2]
    ON [dbo].[tbl_ContactIndividual]([IndividualID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ContactIndividual_3]
    ON [dbo].[tbl_ContactIndividual]([IndividualID] ASC);

