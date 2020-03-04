CREATE TABLE [dbo].[tbl_DealOfficePermission] (
    [DealOfficePermissionID] INT          IDENTITY (1, 1) NOT NULL,
    [OfficeID]               INT          NULL,
    [RoleID]                 VARCHAR (50) NULL,
    [CreatedDate]            DATETIME     NULL,
    [ModifiedDate]           DATETIME     NULL,
    CONSTRAINT [PK_tbl_DealOfficePermission] PRIMARY KEY CLUSTERED ([DealOfficePermissionID] ASC)
);

