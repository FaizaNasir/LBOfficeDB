CREATE TABLE [dbo].[tbl_InterestAppetiteSizePreference] (
    [InterestSizePreferenceID] INT           IDENTITY (1, 1) NOT NULL,
    [MinimumInvestmentSize]    INT           NULL,
    [CurrencyID]               INT           NULL,
    [MaximumInvestmentSize]    INT           NULL,
    [ObjectID]                 INT           NULL,
    [CreatedBy]                VARCHAR (MAX) NULL,
    [DateTime]                 DATETIME      NULL,
    [IsCompany]                BIT           NULL,
    CONSTRAINT [PK_tbl_InterestAppetiteSizePreference] PRIMARY KEY CLUSTERED ([InterestSizePreferenceID] ASC)
);

