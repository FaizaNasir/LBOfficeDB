CREATE TABLE [dbo].[tbl_InterestAppetiteGeographyCountry] (
    [InterestAppetiteGeoghraphyCountryID] INT           IDENTITY (1, 1) NOT NULL,
    [CreatedBy]                           VARCHAR (MAX) NULL,
    [DateTime]                            DATETIME      NULL,
    [ObjectID]                            NCHAR (10)    NULL,
    [Percentage]                          INT           NULL,
    [IsCompany]                           INT           NULL,
    CONSTRAINT [PK_tbl_InterestAppetiteGeographyCountry] PRIMARY KEY CLUSTERED ([InterestAppetiteGeoghraphyCountryID] ASC)
);

