CREATE TABLE [dbo].[tbl_VehiclePortfolioFund] (
    [VehicleID]       INT NOT NULL,
    [PortfolioFundID] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([VehicleID] ASC, [PortfolioFundID] ASC),
    CONSTRAINT [FK_tbl_PortfolioFund_Vehicle] FOREIGN KEY ([PortfolioFundID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID]),
    CONSTRAINT [FK_tbl_Vehicle_PortfolioFund] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehiclePortfolioFund] NOCHECK CONSTRAINT [FK_tbl_PortfolioFund_Vehicle];


GO
ALTER TABLE [dbo].[tbl_VehiclePortfolioFund] NOCHECK CONSTRAINT [FK_tbl_Vehicle_PortfolioFund];

