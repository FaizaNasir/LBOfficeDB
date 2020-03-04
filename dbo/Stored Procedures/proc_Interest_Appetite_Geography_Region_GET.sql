CREATE PROCEDURE [dbo].[proc_Interest_Appetite_Geography_Region_GET] @ObjectID  INT = NULL, 
                                                                     @IsCompany BIT = NULL
AS
    BEGIN
        SELECT [InterestAppetiteGeoghraphyRegionID], 
               [CreatedBy], 
               [DateTime], 
               [ObjectID], 
               [Percentage], 
               [ContenentName], 
               [IsCompany]
        FROM tbl_InterestAppetiteGeographyRegion
             LEFT OUTER JOIN tbl_InterestGeoghraphyRegionDetail ON tbl_InterestAppetiteGeographyRegion.InterestAppetiteGeoghraphyRegionID = tbl_InterestGeoghraphyRegionDetail.InterestAppetiteGeoghraphyCountryID
             INNER JOIN tbl_Contenents ON tbl_Contenents.ContenentID = tbl_InterestGeoghraphyRegionDetail.RegionID
        WHERE ObjectID = ISNULL(@ObjectID, ObjectID)
              AND IsCompany = ISNULL(@IsCompany, IsCompany);
    END;
