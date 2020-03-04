CREATE TABLE [dbo].[tbl_CompanyRevenuesByGeography] (
    [CompanyRevenuesGeographyID] INT            IDENTITY (1, 1) NOT NULL,
    [Description]                NVARCHAR (MAX) NULL,
    [Year]                       NCHAR (10)     NULL,
    [Revenues]                   INT            NULL,
    [CompanyID]                  INT            NULL,
    [ContinentID]                INT            NULL,
    CONSTRAINT [PK_tbl_DealBusinessGeography] PRIMARY KEY CLUSTERED ([CompanyRevenuesGeographyID] ASC)
);

