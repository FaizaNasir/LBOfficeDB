CREATE TABLE [dbo].[tbl_PortfolioValuationMethod] (
    [ValuationMethodID]   INT            IDENTITY (1, 1) NOT NULL,
    [ValuationMethodName] VARCHAR (1000) NULL,
    [Active]              BIT            CONSTRAINT [DF_tbl_PortfolioValuationMethod_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]     DATETIME       NULL,
    [ModifiedDateTime]    DATETIME       NULL,
    [CreatedBy]           VARCHAR (100)  NULL,
    [ModifiedBy]          VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_PortfolioValuationMethod] PRIMARY KEY CLUSTERED ([ValuationMethodID] ASC)
);

