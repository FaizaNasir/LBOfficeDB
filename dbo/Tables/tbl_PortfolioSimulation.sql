CREATE TABLE [dbo].[tbl_PortfolioSimulation] (
    [PortfolioSimulationID] INT             IDENTITY (1, 1) NOT NULL,
    [TargetPortfolioID]     INT             NULL,
    [VehicleID]             INT             NULL,
    [Name]                  VARCHAR (1000)  NULL,
    [IRR]                   DECIMAL (18, 2) NULL,
    [Multiple]              DECIMAL (18, 2) NULL,
    [UserName]              VARCHAR (100)   NULL,
    [Date]                  DATETIME        NULL,
    [Notes]                 VARCHAR (MAX)   NOT NULL,
    [Active]                BIT             CONSTRAINT [DF_tbl_PortfolioSimulation_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]       DATETIME        NULL,
    [ModifiedDateTime]      DATETIME        NULL,
    [CreatedBy]             VARCHAR (100)   NULL,
    [ModifiedBy]            VARCHAR (100)   NULL,
    [IsFund]                BIT             NULL,
    CONSTRAINT [PK_tbl_PortfolioSimulation] PRIMARY KEY CLUSTERED ([PortfolioSimulationID] ASC)
);

