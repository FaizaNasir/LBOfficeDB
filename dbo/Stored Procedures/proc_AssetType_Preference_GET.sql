CREATE PROCEDURE [dbo].[proc_AssetType_Preference_GET] @AssetTypePerferenceID INT = NULL
AS
    BEGIN
        SELECT [AssetTypePerferenceID], 
               [AssetTypePerferenceDesc]
        FROM tbl_AssetTypePerference
        WHERE AssetTypePerferenceID = ISNULL(@AssetTypePerferenceID, AssetTypePerferenceID);
    END;
