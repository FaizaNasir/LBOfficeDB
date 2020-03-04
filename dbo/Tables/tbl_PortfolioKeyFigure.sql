CREATE TABLE [dbo].[tbl_PortfolioKeyFigure] (
    [KeyFIgureID]       INT            IDENTITY (1, 1) NOT NULL,
    [PortfolioID]       INT            NULL,
    [TargetPortfolioID] INT            NULL,
    [KeyFigureConfigID] INT            NULL,
    [Year]              DATETIME       NULL,
    [Amount]            VARCHAR (1000) NULL,
    [Active]            BIT            CONSTRAINT [DF_PortfolioKeyFigure_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]   DATETIME       NULL,
    [ModifiedDateTime]  DATETIME       NULL,
    [CreatedBy]         VARCHAR (100)  NULL,
    [ModifiedBy]        VARCHAR (100)  NULL,
    [SubTab]            INT            NULL,
    [Date]              DATETIME       NULL,
    CONSTRAINT [PK_PortfolioKeyFigure] PRIMARY KEY CLUSTERED ([KeyFIgureID] ASC),
    CONSTRAINT [PortfolioKeyFigurePortfolioID] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[tbl_Portfolio] ([PortfolioID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioKeyFigure] NOCHECK CONSTRAINT [PortfolioKeyFigurePortfolioID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioKeyFigure]
    ON [dbo].[tbl_PortfolioKeyFigure]([PortfolioID] ASC);

