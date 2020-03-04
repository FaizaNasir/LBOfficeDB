CREATE TABLE [dbo].[tbl_CompanyRevenuesByProduct] (
    [CompanyRevenuesProductID] INT            IDENTITY (1, 1) NOT NULL,
    [Description]              NVARCHAR (MAX) NULL,
    [Year]                     NCHAR (10)     NULL,
    [Revenues]                 INT            NULL,
    [Type]                     VARCHAR (250)  NULL,
    [CompanyID]                INT            NULL,
    [TypeName]                 NVARCHAR (250) NULL,
    CONSTRAINT [PK_tbl_DealBusinessRevenues] PRIMARY KEY CLUSTERED ([CompanyRevenuesProductID] ASC)
);

