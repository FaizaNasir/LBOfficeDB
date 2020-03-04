CREATE PROCEDURE [dbo].[proc_Interest_Appetite_Geography_Country_Transaction_Type_Detail_GET] @InterestAppetiteGeoghraphyCountryID INT = NULL
AS
    BEGIN
        SELECT [InterestGeoghraphyCountryTransactionID], 
               [TransactionID], 
               [InterestAppetiteGeoghraphyCountryID]
        FROM tbl_InterestGeographyCountryTransactionTypeDetail
        WHERE InterestAppetiteGeoghraphyCountryID = ISNULL(@InterestAppetiteGeoghraphyCountryID, InterestAppetiteGeoghraphyCountryID);
    END;
