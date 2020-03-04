CREATE TABLE [dbo].[tbl_ContactTypePermission] (
    [ContactTypePermissionID] INT            IDENTITY (1, 1) NOT NULL,
    [RoleID]                  NVARCHAR (256) NULL,
    [ContactTypesID]          INT            NULL,
    [canView]                 BIT            NULL,
    [canEdit]                 BIT            NULL,
    [ModuleID]                INT            NULL,
    [RestrictLinkedContacts]  BIT            NULL,
    CONSTRAINT [PK_tbl_ContactTypePermission] PRIMARY KEY CLUSTERED ([ContactTypePermissionID] ASC),
    CONSTRAINT [FK_tbl_ContactTypePermission_tbl_ContactType] FOREIGN KEY ([ContactTypesID]) REFERENCES [dbo].[tbl_ContactType] ([ContactTypesID])
);


GO
ALTER TABLE [dbo].[tbl_ContactTypePermission] NOCHECK CONSTRAINT [FK_tbl_ContactTypePermission_tbl_ContactType];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ContactTypePermission]
    ON [dbo].[tbl_ContactTypePermission]([ContactTypesID] ASC);

