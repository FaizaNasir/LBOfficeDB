CREATE TABLE [dbo].[tbl_LPTemplateConfig] (
    [LPTemplateConfigID] INT            IDENTITY (1, 1) NOT NULL,
    [VehicleID]          INT            NULL,
    [DocumentTypeID]     INT            NULL,
    [Name]               VARCHAR (1000) NULL,
    [Report]             VARCHAR (3000) NULL,
    [Subject]            VARCHAR (1000) NULL,
    [Email]              VARCHAR (3000) NULL,
    [Notes]              VARCHAR (MAX)  NULL,
    [Active]             BIT            NULL,
    [CreatedDate]        DATETIME       NULL,
    [ModifiedDate]       DATETIME       NULL,
    [CreatedBy]          VARCHAR (100)  NULL,
    [ModifiedBy]         VARCHAR (100)  NULL,
    [Lang]               VARCHAR (100)  NULL,
    [FileName]           VARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_LPTemplateConfig] PRIMARY KEY CLUSTERED ([LPTemplateConfigID] ASC)
);

