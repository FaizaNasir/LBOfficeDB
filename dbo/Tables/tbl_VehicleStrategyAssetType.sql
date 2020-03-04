CREATE TABLE [dbo].[tbl_VehicleStrategyAssetType] (
    [VehicleStrategyAssetID] INT           IDENTITY (1, 1) NOT NULL,
    [AssetTypeID]            INT           NULL,
    [CreatedDateTime]        DATETIME      NULL,
    [ModifiedDateTime]       DATETIME      NULL,
    [Percentage]             INT           NULL,
    [IsInclude]              BIT           NULL,
    [VehicleID]              INT           NULL,
    [CreatedBy]              VARCHAR (100) NULL,
    [ModifiedBy]             VARCHAR (100) NULL,
    [Active]                 BIT           NULL,
    CONSTRAINT [PK_tbl_FundStrategyAssetType] PRIMARY KEY CLUSTERED ([VehicleStrategyAssetID] ASC),
    CONSTRAINT [VehicleStrategyAssetTypeVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleStrategyAssetType] NOCHECK CONSTRAINT [VehicleStrategyAssetTypeVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleStrategyAssetType]
    ON [dbo].[tbl_VehicleStrategyAssetType]([VehicleID] ASC);

