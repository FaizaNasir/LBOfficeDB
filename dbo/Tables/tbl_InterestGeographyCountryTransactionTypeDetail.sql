CREATE TABLE [dbo].[tbl_InterestGeographyCountryTransactionTypeDetail] (
    [InterestGeoghraphyCountryTransactionID] INT IDENTITY (1, 1) NOT NULL,
    [InterestAppetiteGeoghraphyCountryID]    INT NULL,
    [TransactionID]                          INT NULL,
    CONSTRAINT [PK_tbl_InterestGeographyCountryTransactionTypeDetail] PRIMARY KEY CLUSTERED ([InterestGeoghraphyCountryTransactionID] ASC)
);

