CREATE TABLE [dbo].[tbl_VehicleStrategyDealType] (
    [VehicleStrategyDealTypeID] INT           IDENTITY (1, 1) NOT NULL,
    [DealTypeID]                INT           NULL,
    [CreatedDateTime]           DATETIME      NULL,
    [ModifiedDateTime]          DATETIME      NULL,
    [Percentage]                INT           NULL,
    [IsInclude]                 BIT           NULL,
    [VehicleID]                 INT           NULL,
    [CreatedBy]                 VARCHAR (100) NULL,
    [ModifiedBy]                VARCHAR (100) NULL,
    [Active]                    BIT           NULL,
    CONSTRAINT [PK_tbl_FundStrategyDealType] PRIMARY KEY CLUSTERED ([VehicleStrategyDealTypeID] ASC),
    CONSTRAINT [VehicleStrategyDealTypeVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleStrategyDealType] NOCHECK CONSTRAINT [VehicleStrategyDealTypeVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleStrategyDealType]
    ON [dbo].[tbl_VehicleStrategyDealType]([VehicleID] ASC);

