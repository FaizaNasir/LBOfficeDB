CREATE TABLE [dbo].[tbl_PortfolioValuationType] (
    [ValuationTypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [ValuationTypeName] VARCHAR (1000) NULL,
    [Active]            BIT            CONSTRAINT [DF_tbl_PortfolioValuationType_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]   DATETIME       NULL,
    [ModifiedDateTime]  DATETIME       NULL,
    [CreatedBy]         VARCHAR (100)  NULL,
    [ModifiedBy]        VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_PortfolioValuationType] PRIMARY KEY CLUSTERED ([ValuationTypeID] ASC)
);

