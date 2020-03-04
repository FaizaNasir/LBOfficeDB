CREATE TABLE [dbo].[tbl_VehicleHeadquarter] (
    [VehicleHeadquarterID]   INT           IDENTITY (1, 1) NOT NULL,
    [VehicleHeadquarterName] VARCHAR (100) NULL,
    [Active]                 BIT           NULL,
    [CreatedDateTime]        DATETIME      NULL,
    [ModifiedDateTime]       DATETIME      NULL,
    [CreatedBy]              VARCHAR (100) NULL,
    [ModifiedBy]             VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_VehicleHeadquarter] PRIMARY KEY CLUSTERED ([VehicleHeadquarterID] ASC)
);

