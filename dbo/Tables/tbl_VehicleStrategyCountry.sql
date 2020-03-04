CREATE TABLE [dbo].[tbl_VehicleStrategyCountry] (
    [VehicleStrategyCountryID] INT           IDENTITY (1, 1) NOT NULL,
    [CountryID]                INT           NULL,
    [CreatedDateTime]          DATETIME      NULL,
    [ModifiedDateTime]         DATETIME      NULL,
    [Percentage]               INT           NULL,
    [IsInclude]                INT           NULL,
    [VehicleID]                INT           NULL,
    [CreatedBy]                VARCHAR (100) NULL,
    [ModifiedBy]               VARCHAR (100) NULL,
    [Active]                   BIT           NULL,
    CONSTRAINT [PK_tbl_FundStrategyCountry] PRIMARY KEY CLUSTERED ([VehicleStrategyCountryID] ASC),
    CONSTRAINT [VehicleStrategyCountryVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleStrategyCountry] NOCHECK CONSTRAINT [VehicleStrategyCountryVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleStrategyCountry]
    ON [dbo].[tbl_VehicleStrategyCountry]([VehicleID] ASC);

