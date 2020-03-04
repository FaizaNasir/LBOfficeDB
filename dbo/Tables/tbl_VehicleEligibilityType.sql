CREATE TABLE [dbo].[tbl_VehicleEligibilityType] (
    [VehicleEligibilityTypeID]   INT           IDENTITY (1, 1) NOT NULL,
    [VehicleEligibilityTypeName] VARCHAR (100) NULL,
    [Active]                     BIT           NULL,
    [CreatedDateTime]            DATETIME      NULL,
    [ModifiedDateTime]           DATETIME      NULL,
    [CreatedBy]                  VARCHAR (100) NULL,
    [ModifiedBy]                 VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_VehicleEligibilityType] PRIMARY KEY CLUSTERED ([VehicleEligibilityTypeID] ASC)
);

