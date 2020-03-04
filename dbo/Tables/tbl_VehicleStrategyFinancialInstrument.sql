CREATE TABLE [dbo].[tbl_VehicleStrategyFinancialInstrument] (
    [VehicleStrategyFinancialID] INT           IDENTITY (1, 1) NOT NULL,
    [FinancialInstrumentID]      INT           NULL,
    [CreatedDateTime]            DATETIME      NULL,
    [ModifiedDateTime]           DATETIME      NULL,
    [Percentage]                 INT           NULL,
    [IsInclude]                  BIT           NULL,
    [VehicleID]                  INT           NULL,
    [CreatedBy]                  VARCHAR (100) NULL,
    [ModifiedBy]                 VARCHAR (100) NULL,
    [Active]                     BIT           NULL,
    CONSTRAINT [PK_tbl_FundStrategyFinancialInstruments] PRIMARY KEY CLUSTERED ([VehicleStrategyFinancialID] ASC),
    CONSTRAINT [VehicleStrategyFinancialInstrumentVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleStrategyFinancialInstrument] NOCHECK CONSTRAINT [VehicleStrategyFinancialInstrumentVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleStrategyFinancialInstrument]
    ON [dbo].[tbl_VehicleStrategyFinancialInstrument]([VehicleID] ASC);

