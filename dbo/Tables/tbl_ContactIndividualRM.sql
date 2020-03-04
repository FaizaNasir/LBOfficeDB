CREATE TABLE [dbo].[tbl_ContactIndividualRM] (
    [Id]                            INT IDENTITY (1, 1) NOT NULL,
    [IndividualId]                  INT NULL,
    [ManagementCompanyIndividualID] INT NULL,
    [IsMain]                        BIT NULL,
    CONSTRAINT [PK_tbl_ContactIndividualRM] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ContactIndividualRM]
    ON [dbo].[tbl_ContactIndividualRM]([IsMain] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ContactIndividualRM_1]
    ON [dbo].[tbl_ContactIndividualRM]([IndividualId] ASC);

