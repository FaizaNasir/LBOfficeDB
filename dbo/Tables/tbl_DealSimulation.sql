CREATE TABLE [dbo].[tbl_DealSimulation] (
    [DealSimulationID]  INT           IDENTITY (1, 1) NOT NULL,
    [DealID]            INT           NULL,
    [TransectionTypeID] INT           NULL,
    [Active]            BIT           NULL,
    [CreatedDateTime]   DATETIME      NULL,
    [ModifiedDateTime]  DATETIME      NULL,
    [CreatedBy]         VARCHAR (100) NULL,
    [ModifiedBy]        VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_DealSimulation] PRIMARY KEY CLUSTERED ([DealSimulationID] ASC)
);

