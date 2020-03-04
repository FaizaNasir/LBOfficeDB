CREATE TABLE [dbo].[tbl_VehicleCash] (
    [VehicleCashID]    INT             IDENTITY (1, 1) NOT NULL,
    [VehicleID]        INT             NULL,
    [Amount]           DECIMAL (18, 2) NULL,
    [Currency]         VARCHAR (50)    NULL,
    [Date]             DATE            NULL,
    [CreatedDateTime]  DATETIME        NULL,
    [ModifiedDateTime] DATETIME        NULL,
    [CreatedBy]        VARCHAR (100)   NULL,
    [ModifiedBy]       VARCHAR (100)   NULL,
    [Active]           BIT             NULL,
    CONSTRAINT [PK_tbl_VehivleCash] PRIMARY KEY CLUSTERED ([VehicleCashID] ASC)
);

