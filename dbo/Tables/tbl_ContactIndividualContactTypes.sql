CREATE TABLE [dbo].[tbl_ContactIndividualContactTypes] (
    [ContactIndividualContactTypeID] INT      IDENTITY (1, 1) NOT NULL,
    [ContactIndividualID]            INT      NULL,
    [ContactIndividualTypeID]        INT      NULL,
    [Active]                         BIT      CONSTRAINT [DF_tbl_ContactIndividualContactTypes_Active] DEFAULT ((1)) NULL,
    [CreateDateTime]                 DATETIME NULL,
    CONSTRAINT [PK_tbl_ContactIndividualContactTypes] PRIMARY KEY CLUSTERED ([ContactIndividualContactTypeID] ASC),
    CONSTRAINT [FK_tbl_ContactIndividualContactTypes_tbl_ContactIndividual] FOREIGN KEY ([ContactIndividualID]) REFERENCES [dbo].[tbl_ContactIndividual] ([IndividualID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tbl_ContactIndividualContactTypes_tbl_ContactType] FOREIGN KEY ([ContactIndividualTypeID]) REFERENCES [dbo].[tbl_ContactType] ([ContactTypesID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [dbo].[tbl_ContactIndividualContactTypes] NOCHECK CONSTRAINT [FK_tbl_ContactIndividualContactTypes_tbl_ContactIndividual];


GO
ALTER TABLE [dbo].[tbl_ContactIndividualContactTypes] NOCHECK CONSTRAINT [FK_tbl_ContactIndividualContactTypes_tbl_ContactType];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ContactIndividualContactTypes]
    ON [dbo].[tbl_ContactIndividualContactTypes]([ContactIndividualID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ContactIndividualContactTypes_1]
    ON [dbo].[tbl_ContactIndividualContactTypes]([ContactIndividualTypeID] ASC);

