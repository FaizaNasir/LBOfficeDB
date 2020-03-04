CREATE TABLE [dbo].[tbl_InterestAppetiteAssetTypePerferenceTransactionTypeDetail] (
    [AssetTypePerferenceTypeDetailID]       INT IDENTITY (1, 1) NOT NULL,
    [AssetTypePerferenceTypeID]             INT NULL,
    [InterestAppetiteAssetTypePreferenceID] INT NULL,
    CONSTRAINT [PK_tbl_AssetTypePerferenceTypeDetail] PRIMARY KEY CLUSTERED ([AssetTypePerferenceTypeDetailID] ASC)
);

