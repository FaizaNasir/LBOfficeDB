CREATE TABLE [dbo].[tbl_ModuleObjectPermissionsBU] (
    [PermissionID]           INT           IDENTITY (1, 1) NOT NULL,
    [ModuleID]               INT           NULL,
    [ModuleName]             VARCHAR (100) NULL,
    [RoleID]                 VARCHAR (50)  NULL,
    [ModuleObjectID]         INT           NULL,
    [canView]                BIT           NULL,
    [canEdit]                BIT           NULL,
    [RestrictLinkedContacts] BIT           NULL,
    [NoAccess]               BIT           NULL
);

