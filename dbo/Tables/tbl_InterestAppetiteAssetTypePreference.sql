CREATE TABLE [dbo].[tbl_InterestAppetiteAssetTypePreference] (
    [InterestAppetiteAssetTypePreferenceID] INT           IDENTITY (1, 1) NOT NULL,
    [Percentage]                            INT           NULL,
    [Username]                              VARCHAR (MAX) NULL,
    [DateTime]                              DATETIME      NULL,
    [ObjectID]                              INT           NULL,
    [IsCompany]                             BIT           NULL,
    CONSTRAINT [PK_tbl_InvestoAppetiteAssetTypePreference] PRIMARY KEY CLUSTERED ([InterestAppetiteAssetTypePreferenceID] ASC)
);

