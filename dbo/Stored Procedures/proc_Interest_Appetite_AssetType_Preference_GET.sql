CREATE PROCEDURE [dbo].[proc_Interest_Appetite_AssetType_Preference_GET] @ObjectID  INT = NULL, 
                                                                         @IsCompany BIT = NULL
AS
    BEGIN
        SELECT tbl_InterestAppetiteAssetTypePreference.[InterestAppetiteAssetTypePreferenceID], 
               [Percentage], 
               [Username], 
               [DateTime], 
               [ObjectID], 
               AT.[AssetTypePerferenceDesc], 
               [IsCompany]
        FROM tbl_InterestAppetiteAssetTypePreference
             LEFT OUTER JOIN tbl_InterestAppetiteAssetTypePerferenceDetails ATP ON tbl_InterestAppetiteAssetTypePreference.InterestAppetiteAssetTypePreferenceID = ATP.InterestAppetiteAssetTypePreferenceID
             INNER JOIN tbl_AssetTypePerference AT ON AT.AssetTypePerferenceID = ATP.AssetTypePerferenceID
        WHERE ObjectID = ISNULL(@ObjectID, ObjectID)
              AND IsCompany = ISNULL(@IsCompany, IsCompany);
    END;
