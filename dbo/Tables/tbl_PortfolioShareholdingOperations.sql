CREATE TABLE [dbo].[tbl_PortfolioShareholdingOperations] (
    [ShareholdingOperationID] INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioID]             INT             NULL,
    [Name]                    VARCHAR (1000)  NULL,
    [Date]                    DATETIME        NULL,
    [Amount]                  DECIMAL (18, 2) NULL,
    [SecurityID]              INT             NULL,
    [Number]                  DECIMAL (18, 2) NULL,
    [FromID]                  INT             NULL,
    [ToID]                    INT             NULL,
    [FromTypeID]              INT             NULL,
    [ToTypeID]                INT             NULL,
    [isConditional]           BIT             NULL,
    [isConversion]            BIT             NULL,
    [DocumentID]              INT             NULL,
    [Notes]                   VARCHAR (MAX)   NULL,
    [NatureID]                INT             NULL,
    [Active]                  BIT             CONSTRAINT [DF_tbl_PortfolioShareholdingOperations_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]         DATETIME        NULL,
    [ModifiedDateTime]        DATETIME        NULL,
    [CreatedBy]               VARCHAR (100)   NULL,
    [ModifiedBy]              VARCHAR (100)   NULL,
    [ForeignCurrencyAmount]   DECIMAL (18, 2) NULL,
    [ReturnCapitalEUR]        DECIMAL (18, 2) NULL,
    [ReturnCapitalFx]         DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_tbl_PortfolioShareholdingOperations] PRIMARY KEY CLUSTERED ([ShareholdingOperationID] ASC),
    CONSTRAINT [PortfolioShareholdingOperationsPortfolioID] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[tbl_Portfolio] ([PortfolioID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioShareholdingOperations] NOCHECK CONSTRAINT [PortfolioShareholdingOperationsPortfolioID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioShareholdingOperations]
    ON [dbo].[tbl_PortfolioShareholdingOperations]([PortfolioID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioShareholdingOperations_1]
    ON [dbo].[tbl_PortfolioShareholdingOperations]([Date] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioShareholdingOperations_2]
    ON [dbo].[tbl_PortfolioShareholdingOperations]([ToID] ASC, [ToTypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioShareholdingOperations_3]
    ON [dbo].[tbl_PortfolioShareholdingOperations]([FromID] ASC, [FromTypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioShareholdingOperations_4]
    ON [dbo].[tbl_PortfolioShareholdingOperations]([Number] ASC);

