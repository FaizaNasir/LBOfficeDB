CREATE TABLE [dbo].[tbl_TransactionStructure] (
    [TransactionStructureID] INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioID]            INT             NULL,
    [QuasiEquity]            DECIMAL (18, 6) NULL,
    [RevolvingDebt]          DECIMAL (18, 6) NULL,
    [PurchaseShares]         DECIMAL (18, 6) NULL,
    [DebtRepayment]          DECIMAL (18, 6) NULL,
    [TransactionExpenses]    DECIMAL (18, 6) NULL,
    [CashAvailable]          DECIMAL (18, 6) NULL,
    [Active]                 BIT             DEFAULT ((1)) NULL,
    [CreatedDate]            DATETIME        DEFAULT (getdate()) NULL,
    [ModifiedDate]           DATETIME        NULL,
    [CreatedBy]              VARCHAR (1000)  NULL,
    [ModifiedBy]             VARCHAR (1000)  NULL,
    CONSTRAINT [PK_TransactionStructureID] PRIMARY KEY CLUSTERED ([TransactionStructureID] ASC)
);

