CREATE TABLE [dbo].[tbl_VehicleTeam] (
    [VehicleTeamID]           INT           IDENTITY (1, 1) NOT NULL,
    [VehicleID]               INT           NULL,
    [CompanyID]               INT           NULL,
    [ContactID]               INT           NULL,
    [VehicleTeamType]         VARCHAR (100) NULL,
    [Position]                VARCHAR (100) NULL,
    [IsonInvestmentCommittee] BIT           NULL,
    [JoinedOn]                DATE          NULL,
    [LeftOn]                  DATE          NULL,
    [Comments]                VARCHAR (MAX) NULL,
    [Department]              VARCHAR (100) NULL,
    [Active]                  BIT           NULL,
    [CreatedDateTime]         DATETIME      NULL,
    [CreatedBy]               VARCHAR (100) NULL,
    [ModifiedDateTime]        DATETIME      NULL,
    [ModifiedBy]              VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_FundTeamMembers] PRIMARY KEY CLUSTERED ([VehicleTeamID] ASC),
    CONSTRAINT [VehicleTeamVehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [dbo].[tbl_Vehicle] ([VehicleID])
);


GO
ALTER TABLE [dbo].[tbl_VehicleTeam] NOCHECK CONSTRAINT [VehicleTeamVehicleID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehicleTeam]
    ON [dbo].[tbl_VehicleTeam]([VehicleID] ASC);

