CREATE TABLE [dbo].[tbl_PortfolioGeneralOperation] (
    [OperationID]           INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioID]           INT             NULL,
    [Name]                  VARCHAR (1000)  NULL,
    [TypeID]                INT             NULL,
    [Date]                  DATETIME        NULL,
    [Amount]                DECIMAL (18, 2) NULL,
    [CurrencyID]            INT             NULL,
    [FromID]                INT             NULL,
    [ToID]                  INT             NULL,
    [FromModuleID]          INT             NULL,
    [ToModuleID]            INT             NULL,
    [DocumentID]            VARCHAR (MAX)   NULL,
    [Notes]                 VARCHAR (MAX)   NULL,
    [IsConditional]         BIT             NULL,
    [Active]                BIT             CONSTRAINT [DF_tbl_PortfolioGeneralOperation1_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]       DATETIME        NULL,
    [ModifiedDateTime]      DATETIME        NULL,
    [CreatedBy]             VARCHAR (100)   NULL,
    [ModifiedBy]            VARCHAR (100)   NULL,
    [ForeignCurrencyAmount] DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_tbl_PortfolioGeneralOperation1] PRIMARY KEY CLUSTERED ([OperationID] ASC),
    CONSTRAINT [FK_tbl_PortfolioGeneralOperation_tbl_PortfolioGeneralOperationType] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[tbl_PortfolioGeneralOperationType] ([TypeID]),
    CONSTRAINT [PortfolioGeneralOperationPortfolioID] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[tbl_Portfolio] ([PortfolioID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioGeneralOperation] NOCHECK CONSTRAINT [FK_tbl_PortfolioGeneralOperation_tbl_PortfolioGeneralOperationType];


GO
ALTER TABLE [dbo].[tbl_PortfolioGeneralOperation] NOCHECK CONSTRAINT [PortfolioGeneralOperationPortfolioID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioGeneralOperation]
    ON [dbo].[tbl_PortfolioGeneralOperation]([PortfolioID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioGeneralOperation_1]
    ON [dbo].[tbl_PortfolioGeneralOperation]([TypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioGeneralOperation_2]
    ON [dbo].[tbl_PortfolioGeneralOperation]([Date] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioGeneralOperation_3]
    ON [dbo].[tbl_PortfolioGeneralOperation]([ToID] ASC, [ToModuleID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioGeneralOperation_4]
    ON [dbo].[tbl_PortfolioGeneralOperation]([FromID] ASC, [FromModuleID] ASC);

