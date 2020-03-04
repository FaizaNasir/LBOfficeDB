CREATE TABLE [dbo].[tbl_DealStagePermission] (
    [DealStagePermissionID] INT           IDENTITY (1, 1) NOT NULL,
    [DealStageID]           INT           NULL,
    [RoleName]              VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_DealStagePermission] PRIMARY KEY CLUSTERED ([DealStagePermissionID] ASC)
);

