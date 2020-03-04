CREATE PROCEDURE [dbo].[proc_InterestAppetite_AssetType_Perference_Transaction_Type_Detail_GET] @InterestAppetiteAssetTypePreferenceID INT = NULL
AS
    BEGIN
        SELECT [AssetTypePerferenceTypeDetailID], 
               [AssetTypePerferenceTypeID], 
               [InterestAppetiteAssetTypePreferenceID]
        FROM tbl_InterestAppetiteAssetTypePerferenceTransactionTypeDetail
        WHERE InterestAppetiteAssetTypePreferenceID = ISNULL(@InterestAppetiteAssetTypePreferenceID, InterestAppetiteAssetTypePreferenceID);
    END;
