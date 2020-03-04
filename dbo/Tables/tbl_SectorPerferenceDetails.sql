CREATE TABLE [dbo].[tbl_SectorPerferenceDetails] (
    [SectorPerferenceDetailID]   INT IDENTITY (1, 1) NOT NULL,
    [SectorPerferenceID]         INT NULL,
    [AppetiteSectorPerferenceID] INT NULL,
    CONSTRAINT [PK_tbl_SectorPerferenceDetails] PRIMARY KEY CLUSTERED ([SectorPerferenceDetailID] ASC)
);

