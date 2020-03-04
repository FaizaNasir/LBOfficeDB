CREATE TABLE [dbo].[tbl_DealTeam] (
    [DealPartyID]  INT      IDENTITY (1, 1) NOT NULL,
    [DealID]       INT      NULL,
    [IndividualID] INT      NULL,
    [IsTeamLead]   BIT      NULL,
    [CreationDate] DATETIME NULL,
    [IsActive]     BIT      NULL,
    CONSTRAINT [PK_tbl_DealParties] PRIMARY KEY CLUSTERED ([DealPartyID] ASC),
    CONSTRAINT [DealTeamDealID] FOREIGN KEY ([DealID]) REFERENCES [dbo].[tbl_Deals] ([DealID])
);


GO
ALTER TABLE [dbo].[tbl_DealTeam] NOCHECK CONSTRAINT [DealTeamDealID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DealTeam]
    ON [dbo].[tbl_DealTeam]([DealID] ASC);

