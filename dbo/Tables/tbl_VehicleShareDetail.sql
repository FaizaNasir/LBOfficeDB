CREATE TABLE [dbo].[tbl_VehicleShareDetail] (
    [VehicleShareDetailID] INT              IDENTITY (1, 1) NOT NULL,
    [VehicleID]            INT              NULL,
    [ShareDate]            DATETIME         NULL,
    [NominalValue]         NUMERIC (25, 12) NULL,
    [CreatedDateTime]      DATETIME         NULL,
    [CreatedBy]            VARCHAR (100)    NULL,
    [ModifiedDateTime]     DATETIME         NULL,
    [ModifiedBy]           VARCHAR (100)    NULL,
    [Active]               BIT              NULL,
    [ShareID]              INT              NULL,
    CONSTRAINT [PK_tbl_VehicleDetail] PRIMARY KEY CLUSTERED ([VehicleShareDetailID] ASC),
    CONSTRAINT [VehicleShareDetailVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);

