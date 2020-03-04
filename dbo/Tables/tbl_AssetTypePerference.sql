CREATE TABLE [dbo].[tbl_AssetTypePerference] (
    [AssetTypePerferenceID]   INT           IDENTITY (1, 1) NOT NULL,
    [AssetTypePerferenceDesc] VARCHAR (250) NULL,
    CONSTRAINT [PK_tbl_AssetTypePerference] PRIMARY KEY CLUSTERED ([AssetTypePerferenceID] ASC)
);

