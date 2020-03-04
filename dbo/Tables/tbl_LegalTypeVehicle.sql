CREATE TABLE [dbo].[tbl_LegalTypeVehicle] (
    [LegalTypeVehicleID]   INT            IDENTITY (1, 1) NOT NULL,
    [LegalTypeVehicleName] VARCHAR (100)  NULL,
    [Active]               BIT            NULL,
    [CreatedDateTime]      DATETIME       NULL,
    [ModifiedDateTime]     DATETIME       NULL,
    [CreatedBy]            VARCHAR (1000) NULL,
    [ModifiedBy]           VARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_LegalTypeVehicle] PRIMARY KEY CLUSTERED ([LegalTypeVehicleID] ASC)
);

