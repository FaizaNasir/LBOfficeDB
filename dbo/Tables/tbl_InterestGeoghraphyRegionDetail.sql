CREATE TABLE [dbo].[tbl_InterestGeoghraphyRegionDetail] (
    [InterestGeoghraphyRegionID]          INT        IDENTITY (1, 1) NOT NULL,
    [RegionID]                            INT        NULL,
    [InterestAppetiteGeoghraphyCountryID] NCHAR (10) NULL,
    CONSTRAINT [PK_tbl_InterestGeoghraphyRegionDetail] PRIMARY KEY CLUSTERED ([InterestGeoghraphyRegionID] ASC)
);

