CREATE PROCEDURE [dbo].[proc_Interest_Appetite_Geography_Region_Transaction_Type_Detail_GET] @InterestAppetiteGeoghraphyRegionID INT = NULL
AS
    BEGIN
        SELECT [InterestGeoghraphyRegionTransactionID], 
               [InterestAppetiteGeoghraphyRegionID], 
               [TransactionID]
        FROM tbl_InterestGeographyRegionTransactionTypeDetail
        WHERE InterestAppetiteGeoghraphyRegionID = ISNULL(@InterestAppetiteGeoghraphyRegionID, InterestAppetiteGeoghraphyRegionID);
    END;
