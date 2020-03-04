CREATE TABLE [dbo].[tbl_VehicleCatchUp] (
    [CatchupID]        INT              IDENTITY (1, 1) NOT NULL,
    [VehicleID]        INT              NULL,
    [Rate]             DECIMAL (25, 10) NULL,
    [Capitalized]      BIT              NULL,
    [StartDate]        DATETIME         NULL,
    [EndDate]          DATETIME         NULL,
    [Basis]            DECIMAL (25, 10) NULL,
    [CreatedDateTime]  DATETIME         NULL,
    [CreatedBy]        VARCHAR (100)    NULL,
    [ModifiedDateTime] DATETIME         NULL,
    [ModifiedBy]       VARCHAR (100)    NULL,
    [Active]           BIT              NULL,
    CONSTRAINT [PK_tbl_Catchup] PRIMARY KEY CLUSTERED ([CatchupID] ASC),
    CONSTRAINT [VehicleCatchUpVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleCatchUp]
    ON [dbo].[tbl_VehicleCatchUp]([VehicleID] ASC);

