CREATE PROCEDURE [dbo].[proc_InterestAppetitue_AssetType_Perference_Detail_GET] @InterestAppetiteAssetTypePreferenceID INT = NULL
AS
    BEGIN
        SELECT [AssetTypePerferenceDetailID], 
               [AssetTypePerferenceID], 
               [InterestAppetiteAssetTypePreferenceID]
        FROM tbl_InterestAppetiteAssetTypePerferenceDetails
        WHERE InterestAppetiteAssetTypePreferenceID = ISNULL(@InterestAppetiteAssetTypePreferenceID, InterestAppetiteAssetTypePreferenceID);
    END;
