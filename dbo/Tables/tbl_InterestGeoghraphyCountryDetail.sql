CREATE TABLE [dbo].[tbl_InterestGeoghraphyCountryDetail] (
    [InterestGeoghraphyCountryID]         INT        IDENTITY (1, 1) NOT NULL,
    [CountryID]                           INT        NULL,
    [InterestAppetiteGeoghraphyCountryID] NCHAR (10) NULL,
    CONSTRAINT [PK_tbl_InterestGeoghraphyCountryDetail] PRIMARY KEY CLUSTERED ([InterestGeoghraphyCountryID] ASC)
);

