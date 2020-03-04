CREATE TABLE [dbo].[tbl_CompanyContactType] (
    [CompanyContactTypesID] INT      IDENTITY (1, 1) NOT NULL,
    [CompanyContactID]      INT      NULL,
    [ContactTypeID]         INT      NULL,
    [Active]                BIT      CONSTRAINT [DF_tbl_CompanyContactType_Active] DEFAULT ((1)) NULL,
    [CreateDateTime]        DATETIME NULL,
    CONSTRAINT [PK_tbl_CompanyContactType] PRIMARY KEY CLUSTERED ([CompanyContactTypesID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyContactType]
    ON [dbo].[tbl_CompanyContactType]([ContactTypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyContactType_1]
    ON [dbo].[tbl_CompanyContactType]([CompanyContactID] ASC);

