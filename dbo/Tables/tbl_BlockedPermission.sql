CREATE TABLE [dbo].[tbl_BlockedPermission] (
    [BlockedPermissionID] INT            IDENTITY (1, 1) NOT NULL,
    [ModuleName]          VARCHAR (1000) NULL,
    [ObjectID]            INT            NULL,
    [UserRole]            VARCHAR (100)  NULL,
    [Active]              BIT            NULL,
    [CreateDateTime]      DATETIME       NULL,
    [ModifiedDateTime]    DATETIME       NULL,
    [CreatedBy]           VARCHAR (100)  NULL,
    [ModifiedBy]          VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_BlockedPermission] PRIMARY KEY CLUSTERED ([BlockedPermissionID] ASC)
);

