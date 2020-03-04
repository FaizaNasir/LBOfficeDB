CREATE TABLE [dbo].[tbl_SectorPerferenceType] (
    [SectorPerferenceTypeID]   INT          IDENTITY (1, 1) NOT NULL,
    [SectorPerferenceTypeDesc] VARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_SectorPerferenceType] PRIMARY KEY CLUSTERED ([SectorPerferenceTypeID] ASC)
);

