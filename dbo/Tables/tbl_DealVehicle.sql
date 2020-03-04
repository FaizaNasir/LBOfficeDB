CREATE TABLE [dbo].[tbl_DealVehicle] (
    [DealVehicleId]   INT      IDENTITY (1, 1) NOT NULL,
    [VehicleId]       INT      NULL,
    [DealId]          INT      NULL,
    [CreatedDatetime] DATETIME NULL,
    CONSTRAINT [PK_tbl_DealFund] PRIMARY KEY CLUSTERED ([DealVehicleId] ASC),
    CONSTRAINT [DealVehicleDealID] FOREIGN KEY ([DealId]) REFERENCES [dbo].[tbl_Deals] ([DealID])
);


GO
ALTER TABLE [dbo].[tbl_DealVehicle] NOCHECK CONSTRAINT [DealVehicleDealID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DealVehicle]
    ON [dbo].[tbl_DealVehicle]([DealId] ASC);

