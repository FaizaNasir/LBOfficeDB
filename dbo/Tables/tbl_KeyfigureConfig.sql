CREATE TABLE [dbo].[tbl_KeyfigureConfig] (
    [KeyFigureConfigID] INT            IDENTITY (1, 1) NOT NULL,
    [PortfolioID]       INT            NULL,
    [Name]              VARCHAR (1000) NULL,
    [Seq]               INT            NULL,
    [IsReport]          BIT            NULL,
    [IsChart]           BIT            NULL,
    [SubTab]            INT            NULL,
    [Active]            BIT            CONSTRAINT [DF_tbl_KeyfigureConfig_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]   DATETIME       NULL,
    [ModifiedDateTime]  DATETIME       NULL,
    [CreatedBy]         VARCHAR (100)  NULL,
    [ModifiedBy]        VARCHAR (100)  NULL,
    [Date]              DATETIME       NULL,
    [NameFr]            VARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_KeyfigureConfig] PRIMARY KEY CLUSTERED ([KeyFigureConfigID] ASC)
);

