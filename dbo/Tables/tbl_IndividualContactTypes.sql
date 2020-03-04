CREATE TABLE [dbo].[tbl_IndividualContactTypes] (
    [ContactTypesID]  INT      NOT NULL,
    [ContactID]       INT      NULL,
    [ContactTypeID]   INT      NULL,
    [Active]          BIT      NULL,
    [CreatedDateTime] DATETIME NULL,
    CONSTRAINT [PK_tbl_ContactTypes_1] PRIMARY KEY CLUSTERED ([ContactTypesID] ASC),
    CONSTRAINT [FK_tbl_ContactTypes_tbl_ContactIndividual] FOREIGN KEY ([ContactID]) REFERENCES [dbo].[tbl_ContactIndividual] ([IndividualID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tbl_ContactTypes_tbl_ContactType] FOREIGN KEY ([ContactTypeID]) REFERENCES [dbo].[tbl_ContactType] ([ContactTypesID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [dbo].[tbl_IndividualContactTypes] NOCHECK CONSTRAINT [FK_tbl_ContactTypes_tbl_ContactIndividual];


GO
ALTER TABLE [dbo].[tbl_IndividualContactTypes] NOCHECK CONSTRAINT [FK_tbl_ContactTypes_tbl_ContactType];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_IndividualContactTypes]
    ON [dbo].[tbl_IndividualContactTypes]([ContactID] ASC);

