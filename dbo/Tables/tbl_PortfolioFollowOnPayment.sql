CREATE TABLE [dbo].[tbl_PortfolioFollowOnPayment] (
    [FollowOnPaymentID]       INT             IDENTITY (1, 1) NOT NULL,
    [ShareholdingOperationID] INT             NULL,
    [Date]                    DATETIME        NULL,
    [AmountDue]               DECIMAL (18, 2) NULL,
    [Active]                  BIT             CONSTRAINT [DF_tbl_PortfolioFollowOnPayment_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]         DATETIME        NULL,
    [ModifiedDateTime]        DATETIME        NULL,
    [CreatedBy]               VARCHAR (100)   NULL,
    [ModifiedBy]              VARCHAR (100)   NULL,
    [AmountDueFx]             DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_tbl_PortfolioFollowOnPayment] PRIMARY KEY CLUSTERED ([FollowOnPaymentID] ASC),
    CONSTRAINT [PortfolioFollowOnPaymentOperationID] FOREIGN KEY ([ShareholdingOperationID]) REFERENCES [dbo].[tbl_PortfolioShareholdingOperations] ([ShareholdingOperationID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioFollowOnPayment] NOCHECK CONSTRAINT [PortfolioFollowOnPaymentOperationID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioFollowOnPayment]
    ON [dbo].[tbl_PortfolioFollowOnPayment]([ShareholdingOperationID] ASC);

