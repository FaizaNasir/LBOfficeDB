CREATE TABLE [dbo].[tbl_LPTemplateConfigDetail] (
    [LPTemplateConfigDetailID] INT           IDENTITY (1, 1) NOT NULL,
    [LPTemplateConfigID]       INT           NULL,
    [ModuleID]                 INT           NULL,
    [ObjectID]                 INT           NULL,
    [Active]                   BIT           NULL,
    [CreatedDate]              DATETIME      NULL,
    [ModifiedDate]             DATETIME      NULL,
    [CreatedBy]                VARCHAR (100) NULL,
    [ModifiedBy]               VARCHAR (100) NULL,
    [DownloadedDate]           DATETIME      NULL,
    [DownloadedBy]             VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_LPTemplateConfigDetail] PRIMARY KEY CLUSTERED ([LPTemplateConfigDetailID] ASC)
);

