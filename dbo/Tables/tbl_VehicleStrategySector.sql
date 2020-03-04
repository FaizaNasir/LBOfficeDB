CREATE TABLE [dbo].[tbl_VehicleStrategySector] (
    [VehicleStrategySectorID] INT           IDENTITY (1, 1) NOT NULL,
    [SectorID]                INT           NULL,
    [CreatedDateTime]         DATETIME      NULL,
    [ModifiedDateTime]        DATETIME      NULL,
    [Percentage]              INT           NULL,
    [IsInclude]               BIT           NULL,
    [VehicleID]               INT           NULL,
    [CreatedBy]               VARCHAR (100) NULL,
    [ModifiedBy]              VARCHAR (100) NULL,
    [Active]                  BIT           NULL,
    CONSTRAINT [PK_tbl_FundStrategySector] PRIMARY KEY CLUSTERED ([VehicleStrategySectorID] ASC),
    CONSTRAINT [VehicleStrategySectorVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleStrategySector] NOCHECK CONSTRAINT [VehicleStrategySectorVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleStrategySector]
    ON [dbo].[tbl_VehicleStrategySector]([VehicleID] ASC);

