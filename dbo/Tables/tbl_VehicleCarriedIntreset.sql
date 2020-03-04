CREATE TABLE [dbo].[tbl_VehicleCarriedIntreset] (
    [CarriedIntresetID]      INT              IDENTITY (1, 1) NOT NULL,
    [VehicleID]              INT              NULL,
    [IsIRR]                  BIT              NULL,
    [BetweenStartPercent]    DECIMAL (18, 10) NULL,
    [BetweenEndPercent]      DECIMAL (18, 10) NULL,
    [CarriedIntresetPercent] DECIMAL (18, 10) NULL,
    [IsAndOr]                VARCHAR (50)     NULL,
    [CreatedDateTime]        DATETIME         NULL,
    [CreatedBy]              VARCHAR (100)    NULL,
    [ModifiedDateTime]       DATETIME         NULL,
    [ModifiedBy]             VARCHAR (100)    NULL,
    [Active]                 BIT              NULL,
    CONSTRAINT [PK_tbl_CarriedIntreset1] PRIMARY KEY CLUSTERED ([CarriedIntresetID] ASC),
    CONSTRAINT [VehicleCarriedIntresetVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleCarriedIntreset]
    ON [dbo].[tbl_VehicleCarriedIntreset]([VehicleID] ASC);

