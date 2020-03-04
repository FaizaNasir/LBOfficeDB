CREATE TABLE [dbo].[tbl_PortfolioShareholdingOperationsUnderConditions] (
    [ShareholdingOperationID]       INT            NULL,
    [ConditionType]                 VARCHAR (1000) NULL,
    [ConditionSign]                 CHAR (10)      NULL,
    [Value]                         DECIMAL (18)   NULL,
    [IsAndOr]                       VARCHAR (100)  NULL,
    [Active]                        BIT            CONSTRAINT [DF_tbl_PortfolioShareholdingOperationsUnderConditions_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]               DATETIME       NULL,
    [ModifiedDateTime]              DATETIME       NULL,
    [CreatedBy]                     VARCHAR (100)  NULL,
    [ModifiedBy]                    VARCHAR (100)  NULL,
    [ShareholdingUnderConditionsID] INT            IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tbl_PortfolioShareholdingOperationsUnderConditions] PRIMARY KEY CLUSTERED ([ShareholdingUnderConditionsID] ASC),
    CONSTRAINT [FK_tbl_PortfolioShareholdingOperationsUnderConditions_tbl_PortfolioShareholdingOperations] FOREIGN KEY ([ShareholdingOperationID]) REFERENCES [dbo].[tbl_PortfolioShareholdingOperations] ([ShareholdingOperationID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioShareholdingOperationsUnderConditions] NOCHECK CONSTRAINT [FK_tbl_PortfolioShareholdingOperationsUnderConditions_tbl_PortfolioShareholdingOperations];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioShareholdingOperationsUnderConditions]
    ON [dbo].[tbl_PortfolioShareholdingOperationsUnderConditions]([ShareholdingOperationID] ASC);

