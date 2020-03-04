CREATE PROCEDURE [dbo].[proc_Interest_Appetite_Geography_Region_Detail_GET] @InterestAppetiteGeoghraphyCountryID INT = NULL
AS
    BEGIN
        SELECT [InterestGeoghraphyRegionID], 
               [RegionID], 
               [InterestAppetiteGeoghraphyCountryID]
        FROM tbl_InterestGeoghraphyRegionDetail
        WHERE InterestAppetiteGeoghraphyCountryID = ISNULL(@InterestAppetiteGeoghraphyCountryID, InterestAppetiteGeoghraphyCountryID);
    END;
