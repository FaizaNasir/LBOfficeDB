CREATE TABLE [dbo].[tbl_BlockedGroupPermission] (
    [BlockedGroupPermissionID] INT           IDENTITY (1, 1) NOT NULL,
    [ModuleID]                 INT           NULL,
    [TypeID]                   INT           NULL,
    [UserRole]                 VARCHAR (100) NULL,
    [Active]                   BIT           NULL,
    [CreateDateTime]           DATETIME      NULL,
    [ModifiedDateTime]         DATETIME      NULL,
    [CreatedBy]                VARCHAR (100) NULL,
    [ModifiedBy]               VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_BlockedGroupPermission] PRIMARY KEY CLUSTERED ([BlockedGroupPermissionID] ASC)
);

