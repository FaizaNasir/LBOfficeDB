CREATE TABLE [dbo].[tbl_VehicleQuarterlyUpdates] (
    [VehicleQuarterlyUpdateID] INT             IDENTITY (1, 1) NOT NULL,
    [VehicleID]                INT             NULL,
    [Date]                     DATETIME        NULL,
    [UpdateType]               VARCHAR (100)   NULL,
    [IndividualID]             INT             NULL,
    [CreatedDateTime]          DATETIME        NULL,
    [CreatedBy]                VARCHAR (100)   NULL,
    [ModifiedDateTime]         DATETIME        NULL,
    [ModifiedBy]               VARCHAR (100)   NULL,
    [Active]                   BIT             CONSTRAINT [DF_tbl_VehicleQuarterlyUpdates_Active] DEFAULT ((1)) NULL,
    [Language]                 VARCHAR (100)   NULL,
    [Comments]                 VARBINARY (MAX) NULL,
    CONSTRAINT [PK_tbl_FundQuarterlyUpdates] PRIMARY KEY CLUSTERED ([VehicleQuarterlyUpdateID] ASC),
    CONSTRAINT [VehicleQuarterlyUpdatesVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleQuarterlyUpdates] NOCHECK CONSTRAINT [VehicleQuarterlyUpdatesVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleQuarterlyUpdates]
    ON [dbo].[tbl_VehicleQuarterlyUpdates]([VehicleID] ASC);

