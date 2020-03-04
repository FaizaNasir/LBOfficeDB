CREATE TABLE [dbo].[tbl_SectorPerferenceTypeDetail] (
    [SectorPerferenceTypeDetailID]   INT IDENTITY (1, 1) NOT NULL,
    [SectorPerferenceTypeID]         INT NULL,
    [AppetiteSectorPerferenceTypeID] INT NULL,
    CONSTRAINT [PK_tbl_SectorPerferenceTypeDetail] PRIMARY KEY CLUSTERED ([SectorPerferenceTypeDetailID] ASC)
);

