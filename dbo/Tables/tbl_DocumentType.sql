CREATE TABLE [dbo].[tbl_DocumentType] (
    [DocumentTypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [DocumentTypeName] VARCHAR (1000) NULL,
    [Active]           BIT            NULL,
    [CreatedDate]      DATETIME       NULL,
    [ModifiedDate]     DATETIME       NULL,
    [CreatedBy]        VARCHAR (100)  NULL,
    [ModifiedBy]       VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_DocumentType] PRIMARY KEY CLUSTERED ([DocumentTypeID] ASC)
);

