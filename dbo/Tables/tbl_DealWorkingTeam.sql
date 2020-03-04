CREATE TABLE [dbo].[tbl_DealWorkingTeam] (
    [ProjectWorkingTeamID]    INT           NOT NULL,
    [ProjectWorkingTeamTitle] VARCHAR (100) NULL,
    [ProjectWorkingTeamDesc]  VARCHAR (100) NULL,
    [Active]                  BIT           NULL,
    [CreatedDateTime]         DATETIME      NULL,
    CONSTRAINT [PK_tbl_ProjectWorkingTeam] PRIMARY KEY CLUSTERED ([ProjectWorkingTeamID] ASC)
);

