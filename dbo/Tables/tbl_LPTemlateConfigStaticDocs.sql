CREATE TABLE [dbo].[tbl_LPTemlateConfigStaticDocs] (
    [LPTemlateConfigStaticDocsID] INT            IDENTITY (1, 1) NOT NULL,
    [LPTemplateConfigID]          INT            NULL,
    [Location]                    VARCHAR (3000) NULL,
    [Active]                      BIT            NULL,
    [CreatedDate]                 DATETIME       NULL,
    [ModifiedDate]                DATETIME       NULL,
    [CreatedBy]                   VARCHAR (100)  NULL,
    [ModifiedBy]                  VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_LPTemlateConfigStaticDocs] PRIMARY KEY CLUSTERED ([LPTemlateConfigStaticDocsID] ASC)
);

