CREATE TABLE [dbo].[tbl_VehicleStrategyRegion] (
    [VehicleStrategyRegionID] INT           IDENTITY (1, 1) NOT NULL,
    [RegionID]                INT           NULL,
    [CreatedDateTime]         DATETIME      NULL,
    [ModifiedDateTime]        DATETIME      NULL,
    [Percentage]              INT           NULL,
    [IsInclude]               BIT           NULL,
    [VehicleID]               INT           NULL,
    [CreatedBy]               VARCHAR (100) NULL,
    [ModifiedBy]              VARCHAR (100) NULL,
    [Active]                  BIT           NULL,
    CONSTRAINT [PK_tbl_FundStrategyRegion] PRIMARY KEY CLUSTERED ([VehicleStrategyRegionID] ASC),
    CONSTRAINT [VehicleStrategyRegionVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleStrategyRegion] NOCHECK CONSTRAINT [VehicleStrategyRegionVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleStrategyRegion]
    ON [dbo].[tbl_VehicleStrategyRegion]([VehicleID] ASC);

