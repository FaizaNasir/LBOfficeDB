CREATE TABLE [dbo].[tbl_PortfolioFundGeneralOperation] (
    [OperationID]                        INT             IDENTITY (1, 1) NOT NULL,
    [VehicleID]                          INT             NOT NULL,
    [Name]                               VARCHAR (1000)  NULL,
    [TypeID]                             INT             NULL,
    [Date]                               DATETIME        NULL,
    [Amount]                             DECIMAL (18, 2) NULL,
    [CurrencyID]                         INT             NULL,
    [FromID]                             INT             NULL,
    [ToID]                               INT             NULL,
    [FromModuleID]                       INT             NULL,
    [ToModuleID]                         INT             NULL,
    [DocumentID]                         VARCHAR (MAX)   NULL,
    [Notes]                              VARCHAR (MAX)   NULL,
    [IsConditional]                      BIT             NULL,
    [Active]                             BIT             DEFAULT ((1)) NULL,
    [CreatedDateTime]                    DATETIME        NULL,
    [ModifiedDateTime]                   DATETIME        NULL,
    [CreatedBy]                          VARCHAR (100)   NULL,
    [ModifiedBy]                         VARCHAR (100)   NULL,
    [ForeignCurrencyAmount]              DECIMAL (18, 2) NULL,
    [Investment_ReturnOfCapital]         DECIMAL (18, 2) NULL,
    [FeeOther_Profits]                   DECIMAL (18, 2) NULL,
    [Investment_ReturnOfCapital_FX]      DECIMAL (18, 2) NULL,
    [FeeOther_Profits_FX]                DECIMAL (18, 2) NULL,
    [IncludingRecallableDistribution]    DECIMAL (18, 2) NULL,
    [IncludingRecallableDistribution_FX] DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_tbl_PortfolioFundGeneralOperation] PRIMARY KEY CLUSTERED ([OperationID] ASC),
    CONSTRAINT [FK_tbl_PortfolioFundGeneralOperation_tbl_Vehicle] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioFundGeneralOperation] NOCHECK CONSTRAINT [FK_tbl_PortfolioFundGeneralOperation_tbl_Vehicle];

