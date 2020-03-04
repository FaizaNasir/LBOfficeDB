CREATE TABLE [dbo].[tbl_PortfolioSimulationDetail] (
    [PortfolioSimulationDetailID] INT             IDENTITY (1, 1) NOT NULL,
    [PortfolioSimulationID]       INT             NULL,
    [Date]                        DATETIME        NULL,
    [Amount]                      DECIMAL (18, 2) NULL,
    [IsIncluded]                  BIT             NULL,
    [TypeOfOperation]             VARCHAR (100)   NULL,
    [Active]                      BIT             CONSTRAINT [DF_tbl_PortfolioSimulationDetail_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]             DATETIME        NULL,
    [ModifiedDateTime]            DATETIME        NULL,
    [CreatedBy]                   VARCHAR (100)   NULL,
    [ModifiedBy]                  VARCHAR (100)   NULL,
    [PortfolioID]                 INT             NULL,
    CONSTRAINT [PK_tbl_PortfolioSimulationDetail] PRIMARY KEY CLUSTERED ([PortfolioSimulationDetailID] ASC),
    CONSTRAINT [PortfolioSimulationID] FOREIGN KEY ([PortfolioSimulationID]) REFERENCES [dbo].[tbl_PortfolioSimulation] ([PortfolioSimulationID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioSimulationDetail] NOCHECK CONSTRAINT [PortfolioSimulationID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioSimulationDetail]
    ON [dbo].[tbl_PortfolioSimulationDetail]([PortfolioSimulationID] ASC);

