CREATE TABLE [dbo].[tbl_SubVehicles] (
    [SubVehicleID]                INT           IDENTITY (1, 1) NOT NULL,
    [Name]                        VARCHAR (100) NULL,
    [Jurisdiction]                VARCHAR (100) NULL,
    [Ratio]                       INT           NULL,
    [Hasitsowncallsdistributions] BIT           NULL,
    [VehicleID]                   INT           NULL,
    [CreatedDateTime]             DATETIME      NULL,
    [CreatedBy]                   VARCHAR (100) NULL,
    [ModifiedDateTime]            DATETIME      NULL,
    [ModifiedBy]                  VARCHAR (100) NULL,
    [Active]                      BIT           NULL,
    CONSTRAINT [PK_tbl_SubFunds] PRIMARY KEY CLUSTERED ([SubVehicleID] ASC),
    CONSTRAINT [SubVehiclesVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_SubVehicles] NOCHECK CONSTRAINT [SubVehiclesVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_SubVehicles]
    ON [dbo].[tbl_SubVehicles]([VehicleID] ASC);

