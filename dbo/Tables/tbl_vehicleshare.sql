﻿CREATE TABLE [dbo].[tbl_vehicleshare] (
    [VehicleShareID]   INT             IDENTITY (1, 1) NOT NULL,
    [VehicleID]        INT             NULL,
    [ShareName]        VARCHAR (1000)  NULL,
    [NominalValue]     DECIMAL (18, 6) NULL,
    [Hurdle]           BIT             NULL,
    [Catchup]          BIT             NULL,
    [CarriedInterest]  DECIMAL (18, 6) NULL,
    [Notes]            VARCHAR (4000)  NULL,
    [Active]           BIT             CONSTRAINT [DF_tbl_vehicleshare_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]  DATETIME        NULL,
    [ModifiedDateTime] DATETIME        NULL,
    [CreatedBy]        VARCHAR (100)   NULL,
    [ModifiedBy]       VARCHAR (100)   NULL,
    [NominaValueA]     DECIMAL (18, 2) NULL,
    [NominaValueB]     DECIMAL (18, 2) NULL,
    [NominaValueC]     DECIMAL (18, 2) NULL,
    [AssetsofOrigin]   DECIMAL (18, 2) NULL,
    [IsinA]            VARCHAR (1000)  NULL,
    [NetAssets]        DECIMAL (18, 2) NULL,
    [IncludedReport]   BIT             NULL,
    [ShareNameFR]      VARCHAR (1000)  NULL,
    [ExportChart]      BIT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tbl_vehicleshare] PRIMARY KEY CLUSTERED ([VehicleShareID] ASC)
);
