CREATE PROCEDURE [dbo].[proc_Vehicle_Strategy_AssetType_GET] @VehicleID INT          = NULL, 
                                                             @RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT VehicleStrategyAssetID, 
               AssetTypeID, 
               'Type' = CASE IsInclude
                            WHEN '1'
                            THEN 'Include'
                            WHEN '0'
                            THEN 'Exclude'
                        END, 
               Percentage, 
               IsInclude, 
               VehicleID, 
               CreatedBy, 
               ModifiedBy, 
               tbl_VehicleStrategyAssetType.CreatedDateTime, 
               tbl_VehicleStrategyAssetType.ModifiedDateTime, 
               tbl_AssetTypePerference.AssetTypePerferenceDesc, 
               tbl_VehicleStrategyAssetType.Active
        FROM tbl_VehicleStrategyAssetType
             LEFT OUTER JOIN [tbl_AssetTypePerference] ON tbl_VehicleStrategyAssetType.AssetTypeID = tbl_AssetTypePerference.AssetTypePerferenceID
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID);
    END;
