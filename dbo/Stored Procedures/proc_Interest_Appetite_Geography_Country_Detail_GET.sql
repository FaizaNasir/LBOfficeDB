CREATE PROCEDURE [dbo].[proc_Interest_Appetite_Geography_Country_Detail_GET] @InterestAppetiteGeoghraphyCountryID INT = NULL
AS
    BEGIN
        SELECT [InterestGeoghraphyCountryID], 
               [CountryID], 
               [InterestAppetiteGeoghraphyCountryID]
        FROM tbl_InterestGeoghraphyCountryDetail
        WHERE InterestAppetiteGeoghraphyCountryID = ISNULL(@InterestAppetiteGeoghraphyCountryID, InterestAppetiteGeoghraphyCountryID);
    END;
