CREATE TABLE [dbo].[tbl_PortfolioDealTeam] (
    [PortfolioDealTeamID] INT            IDENTITY (1, 1) NOT NULL,
    [PortfolioID]         INT            NULL,
    [ContactIndividualID] INT            NULL,
    [RoleID]              VARCHAR (1000) NULL,
    [Active]              BIT            CONSTRAINT [DF_tbl_PortfolioDealTeam_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]     DATETIME       NULL,
    [ModifiedDateTime]    DATETIME       NULL,
    [CreatedBy]           VARCHAR (100)  NULL,
    [ModifiedBy]          VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_PortfolioDealTeam] PRIMARY KEY CLUSTERED ([PortfolioDealTeamID] ASC),
    CONSTRAINT [PortfolioDealTeamPortfolioID] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[tbl_Portfolio] ([PortfolioID])
);


GO
ALTER TABLE [dbo].[tbl_PortfolioDealTeam] NOCHECK CONSTRAINT [PortfolioDealTeamPortfolioID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioDealTeam]
    ON [dbo].[tbl_PortfolioDealTeam]([PortfolioID] ASC);

