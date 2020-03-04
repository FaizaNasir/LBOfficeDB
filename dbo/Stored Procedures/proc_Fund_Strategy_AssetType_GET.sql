CREATE PROCEDURE [dbo].[proc_Fund_Strategy_AssetType_GET] @FundID INT = NULL
AS
    BEGIN
        SELECT FundStrategyAssetID, 
               AssetTypeID, 
               'Type' = CASE IsInclude
                            WHEN '1'
                            THEN 'Include'
                            WHEN '0'
                            THEN 'Exclude'
                        END, 
               CreatedDateTime, 
               ModifiedDateTime, 
               Percentage, 
               IsInclude, 
               FundID, 
               CreatedBy, 
               ModifiedBy, 
               tbl_AssetTypePerference.AssetTypePerferenceDesc
        FROM tbl_FundStrategyAssetType
             LEFT OUTER JOIN [tbl_AssetTypePerference] ON tbl_FundStrategyAssetType.AssetTypeID = tbl_AssetTypePerference.AssetTypePerferenceID
        WHERE FundID = ISNULL(@FundID, FundID);
    END;
