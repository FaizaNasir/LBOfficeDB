CREATE TABLE [dbo].[tbl_CompanyRevenuesByService] (
    [CompanyRevenuesServiceID] INT            IDENTITY (1, 1) NOT NULL,
    [Description]              NVARCHAR (MAX) NULL,
    [Year]                     NCHAR (10)     NULL,
    [Revenues]                 INT            NULL,
    [Type]                     VARCHAR (250)  NULL,
    [CompanyID]                INT            NULL,
    [TypeName]                 NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_tbl_DealBusinessService] PRIMARY KEY CLUSTERED ([CompanyRevenuesServiceID] ASC)
);

