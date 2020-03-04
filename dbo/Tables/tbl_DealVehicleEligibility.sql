CREATE TABLE [dbo].[tbl_DealVehicleEligibility] (
    [DealVehicleEligibilityID] INT           IDENTITY (1, 1) NOT NULL,
    [DealID]                   INT           NULL,
    [VehicleID]                INT           NULL,
    [Active]                   BIT           NULL,
    [CreatedDateTime]          DATETIME      NULL,
    [ModifiedDateTime]         DATETIME      NULL,
    [CreatedBy]                VARCHAR (100) NULL,
    [ModifiedBy]               VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_DealFundEligibility] PRIMARY KEY CLUSTERED ([DealVehicleEligibilityID] ASC)
);

