CREATE TABLE [dbo].[tbl_InterestGeographyRegionTransactionTypeDetail] (
    [InterestGeoghraphyRegionTransactionID] INT IDENTITY (1, 1) NOT NULL,
    [InterestAppetiteGeoghraphyRegionID]    INT NULL,
    [TransactionID]                         INT NULL,
    CONSTRAINT [PK_tbl_InterestGeographyRegionTransactionTypeDetail] PRIMARY KEY CLUSTERED ([InterestGeoghraphyRegionTransactionID] ASC)
);

