CREATE TABLE [dbo].[tbl_VehicleHurdleRate] (
    [HurdleRateID]     INT              IDENTITY (1, 1) NOT NULL,
    [VehicleID]        INT              NULL,
    [Rate]             DECIMAL (25, 10) NULL,
    [Capitalized]      BIT              NULL,
    [StartDate]        DATETIME         NULL,
    [EndDate]          DATETIME         NULL,
    [Basis]            DECIMAL (25, 10) NULL,
    [CreatedDateTime]  DATETIME         NULL,
    [CreatedBy]        VARCHAR (100)    NULL,
    [ModifiedDatetime] DATETIME         NULL,
    [ModifiedBy]       VARCHAR (100)    NULL,
    [Active]           BIT              NULL,
    CONSTRAINT [PK_tbl_FundHurdleRate] PRIMARY KEY CLUSTERED ([HurdleRateID] ASC),
    CONSTRAINT [VehicleHurdleRateVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleHurdleRate] NOCHECK CONSTRAINT [VehicleHurdleRateVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleHurdleRate]
    ON [dbo].[tbl_VehicleHurdleRate]([VehicleID] ASC);

