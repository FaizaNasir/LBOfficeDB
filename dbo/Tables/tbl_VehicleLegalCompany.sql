CREATE TABLE [dbo].[tbl_VehicleLegalCompany] (
    [VehicleCompanyID] INT IDENTITY (1, 1) NOT NULL,
    [VehicleID]        INT NULL,
    [CompanyID]        INT NULL,
    CONSTRAINT [PK_tbl_VehicleLegalCompany] PRIMARY KEY CLUSTERED ([VehicleCompanyID] ASC)
);

