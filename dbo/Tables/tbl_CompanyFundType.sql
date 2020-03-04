CREATE TABLE [dbo].[tbl_CompanyFundType] (
    [CompanyFundTypeID] INT           NOT NULL,
    [Label]             NVARCHAR (50) NOT NULL,
    [Order]             INT           NULL,
    PRIMARY KEY CLUSTERED ([CompanyFundTypeID] ASC)
);

