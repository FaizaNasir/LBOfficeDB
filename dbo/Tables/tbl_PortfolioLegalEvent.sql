CREATE TABLE [dbo].[tbl_PortfolioLegalEvent] (
    [PortfolioLegalEventID] INT            IDENTITY (1, 1) NOT NULL,
    [PortfolioID]           INT            NULL,
    [DateTime]              DATETIME       NULL,
    [Username]              VARCHAR (1000) NULL,
    [TypeID]                INT            NULL,
    [Comments]              VARCHAR (MAX)  NULL,
    [Active]                BIT            CONSTRAINT [DF_tbl_PortfolioLegalEvent1_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]       DATETIME       NULL,
    [ModifiedDateTime]      DATETIME       NULL,
    [CreatedBy]             VARCHAR (100)  NULL,
    [ModifiedBy]            VARCHAR (100)  NULL,
    [Date]                  DATE           NULL,
    CONSTRAINT [PK_tbl_PortfolioLegalEvent1] PRIMARY KEY CLUSTERED ([PortfolioLegalEventID] ASC)
);

