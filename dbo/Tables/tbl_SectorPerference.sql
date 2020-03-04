CREATE TABLE [dbo].[tbl_SectorPerference] (
    [SectorPerferenceID]   INT           IDENTITY (1, 1) NOT NULL,
    [SectorPerferenceDesc] VARCHAR (250) NULL,
    CONSTRAINT [PK_tbl_SectorPerference] PRIMARY KEY CLUSTERED ([SectorPerferenceID] ASC)
);

