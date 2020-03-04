CREATE TABLE [dbo].[tbl_InterestAppetiteAssetTypePerferenceDetails] (
    [AssetTypePerferenceDetailID]           INT IDENTITY (1, 1) NOT NULL,
    [AssetTypePerferenceID]                 INT NULL,
    [InterestAppetiteAssetTypePreferenceID] INT NULL,
    CONSTRAINT [PK_tbl_AssetTypePerferenceDetails] PRIMARY KEY CLUSTERED ([AssetTypePerferenceDetailID] ASC)
);

