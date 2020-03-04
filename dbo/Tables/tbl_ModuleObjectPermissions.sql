CREATE TABLE [dbo].[tbl_ModuleObjectPermissions] (
    [PermissionID]           INT           IDENTITY (1, 1) NOT NULL,
    [ModuleID]               INT           NULL,
    [ModuleName]             VARCHAR (100) NULL,
    [RoleID]                 VARCHAR (50)  NULL,
    [ModuleObjectID]         INT           NULL,
    [canView]                BIT           CONSTRAINT [DF_tbl_ModuleObjectPermissions_canView] DEFAULT ((1)) NULL,
    [canEdit]                BIT           CONSTRAINT [DF_tbl_ModuleObjectPermissions_canEdit] DEFAULT ((1)) NULL,
    [RestrictLinkedContacts] BIT           NULL,
    [NoAccess]               BIT           NULL,
    CONSTRAINT [PK_tbl_ModuleObjectPermissions] PRIMARY KEY CLUSTERED ([PermissionID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ModuleObjectPermissions]
    ON [dbo].[tbl_ModuleObjectPermissions]([ModuleObjectID] ASC, [ModuleID] ASC);

