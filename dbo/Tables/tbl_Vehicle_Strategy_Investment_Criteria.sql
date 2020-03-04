CREATE TABLE [dbo].[tbl_Vehicle_Strategy_Investment_Criteria] (
    [CriteriaID]       INT           IDENTITY (1, 1) NOT NULL,
    [VehicleID]        INT           NULL,
    [IsAndOr]          CHAR (10)     NULL,
    [ConditionSign]    CHAR (10)     NULL,
    [InvestmentTypeID] INT           NULL,
    [CurrencyID]       INT           NULL,
    [Amount]           NUMERIC (18)  NULL,
    [CreatedDateTime]  DATETIME      NULL,
    [CreatedBy]        VARCHAR (100) NULL,
    [ModifiedDateTime] DATETIME      NULL,
    [ModifiedBy]       VARCHAR (100) NULL,
    [Active]           BIT           NULL,
    CONSTRAINT [PK_tbl_Fund_Strategy_Investment_Criteria] PRIMARY KEY CLUSTERED ([CriteriaID] ASC),
    CONSTRAINT [VehicleStrategyInvestmentCriteriaVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_Vehicle_Strategy_Investment_Criteria] NOCHECK CONSTRAINT [VehicleStrategyInvestmentCriteriaVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Vehicle_Strategy_Investment_Criteria]
    ON [dbo].[tbl_Vehicle_Strategy_Investment_Criteria]([VehicleID] ASC);

