CREATE PROCEDURE [dbo].[proc_Interest_Appetite_Geography_Country_GET]   --487,false    
@ObjectID  INT = NULL, 
@IsCompany BIT = NULL
AS
    BEGIN
        SELECT tbl_InterestAppetiteGeographyCountry.[InterestAppetiteGeoghraphyCountryID], 
               [CreatedBy], 
               [DateTime], 
               [ObjectID], 
               [Percentage], 
               tbl_Country.[CountryName], 
               [IsCompany]
        FROM tbl_InterestAppetiteGeographyCountry
             LEFT OUTER JOIN tbl_InterestGeoghraphyCountryDetail ON tbl_InterestGeoghraphyCountryDetail.InterestAppetiteGeoghraphyCountryID = tbl_InterestAppetiteGeographyCountry.InterestAppetiteGeoghraphyCountryID
             INNER JOIN tbl_Country ON tbl_Country.CountryID = tbl_InterestGeoghraphyCountryDetail.CountryID
        WHERE ObjectID = ISNULL(@ObjectID, ObjectID)
              AND IsCompany = ISNULL(@IsCompany, IsCompany);
    END;
