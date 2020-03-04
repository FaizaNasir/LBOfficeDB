CREATE TABLE [dbo].[tbl_InterestAppetiteGeographyRegion] (
    [InterestAppetiteGeoghraphyRegionID] INT           IDENTITY (1, 1) NOT NULL,
    [CreatedBy]                          VARCHAR (MAX) NULL,
    [DateTime]                           DATETIME      NULL,
    [ObjectID]                           NCHAR (10)    NULL,
    [Percentage]                         INT           NULL,
    [IsCompany]                          BIT           NULL,
    CONSTRAINT [PK_tbl_InterestAppetiteGeographyRegion] PRIMARY KEY CLUSTERED ([InterestAppetiteGeoghraphyRegionID] ASC)
);

