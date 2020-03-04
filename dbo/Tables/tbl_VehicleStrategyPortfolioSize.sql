CREATE TABLE [dbo].[tbl_VehicleStrategyPortfolioSize] (
    [VehicleStrategyPortfolioSizeID] INT           IDENTITY (1, 1) NOT NULL,
    [ForecastFrom]                   DECIMAL (18)  NULL,
    [ForecastTo]                     DECIMAL (18)  NULL,
    [InvestmentFrom]                 DECIMAL (18)  NULL,
    [InvertmentTo]                   DECIMAL (18)  NULL,
    [CreatedDateTime]                DATETIME      NULL,
    [ModifiedDateTime]               DATETIME      NULL,
    [VehicleID]                      INT           NULL,
    [CreatedBy]                      VARCHAR (100) NULL,
    [ModifiedBy]                     VARCHAR (100) NULL,
    [Active]                         BIT           NULL,
    CONSTRAINT [PK_tbl_FundStrategyPortfolioSize] PRIMARY KEY CLUSTERED ([VehicleStrategyPortfolioSizeID] ASC),
    CONSTRAINT [VehicleStrategyPortfolioSizeVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleStrategyPortfolioSize] NOCHECK CONSTRAINT [VehicleStrategyPortfolioSizeVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleStrategyPortfolioSize]
    ON [dbo].[tbl_VehicleStrategyPortfolioSize]([VehicleID] ASC);

