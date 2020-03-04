CREATE TABLE [dbo].[tbl_DealCompany] (
    [DealCompanyID] INT IDENTITY (1, 1) NOT NULL,
    [DealID]        INT NULL,
    [CompanyID]     INT NULL,
    CONSTRAINT [PK_tbl_DealCompany] PRIMARY KEY CLUSTERED ([DealCompanyID] ASC)
);

