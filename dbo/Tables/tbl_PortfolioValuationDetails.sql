CREATE TABLE [dbo].[tbl_PortfolioValuationDetails] (
    [ValuationDetailID] INT           IDENTITY (1, 1) NOT NULL,
    [SecurityID]        INT           NULL,
    [Value]             DECIMAL (18)  NULL,
    [ValuationID]       INT           NULL,
    [Stock]             DECIMAL (18)  NULL,
    [Active]            BIT           CONSTRAINT [DF_tbl_PortfolioValuationDetails_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]   DATETIME      NULL,
    [ModifiedDateTime]  DATETIME      NULL,
    [CreatedBy]         VARCHAR (100) NULL,
    [ModifiedBy]        VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_PortfolioValuationDetails] PRIMARY KEY CLUSTERED ([ValuationDetailID] ASC),
    CONSTRAINT [ValuationID] FOREIGN KEY ([ValuationID]) REFERENCES [dbo].[tbl_PortfolioValuation] ([ValuationID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioValuationDetails] NOCHECK CONSTRAINT [ValuationID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioValuationDetails]
    ON [dbo].[tbl_PortfolioValuationDetails]([ValuationID] ASC);

