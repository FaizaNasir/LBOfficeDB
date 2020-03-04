CREATE TABLE [dbo].[tbl_VehicleRatio] (
    [VehicleRatioID]         INT             IDENTITY (1, 1) NOT NULL,
    [VehicleID]              INT             NULL,
    [RatioPrinciple]         DECIMAL (18, 2) NULL,
    [RatioCapital]           DECIMAL (18, 2) NULL,
    [Ratio5Year]             DECIMAL (18, 2) NULL,
    [Ratio8Year]             DECIMAL (18, 2) NULL,
    [RatioReglemente]        DECIMAL (18, 2) NULL,
    [RatioNonRelemente]      DECIMAL (18, 2) NULL,
    [RatioCapitalIncrease]   DECIMAL (18, 2) NULL,
    [RatioConvertibaleBonds] DECIMAL (18, 2) NULL,
    [RatioTransferSecurity]  DECIMAL (18, 2) NULL,
    [RatioCurrentAccount]    DECIMAL (18, 2) NULL,
    [RatioRegion]            DECIMAL (18, 2) NULL,
    [Active]                 BIT             NULL,
    [CreatedDateTime]        DATETIME        NULL,
    [ModifiedDateTime]       DATETIME        NULL,
    [CreatedBy]              VARCHAR (100)   NULL,
    [ModifiedBy]             VARCHAR (100)   NULL,
    CONSTRAINT [PK_tbl_VehicleRatio] PRIMARY KEY CLUSTERED ([VehicleRatioID] ASC)
);

