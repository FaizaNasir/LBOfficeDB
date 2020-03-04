CREATE PROCEDURE [dbo].[proc_VehicleRatio_GET] --19  

@Vehicle INT = NULL
AS
    BEGIN
        SELECT [VehicleRatioID], 
               [VehicleID], 
               [RatioPrinciple], 
               [RatioCapital], 
               [Ratio5Year], 
               [Ratio8Year], 
               [RatioReglemente], 
               [RatioNonRelemente], 
               [RatioCapitalIncrease], 
               [RatioConvertibaleBonds], 
               [RatioTransferSecurity], 
               [RatioCurrentAccount], 
               [RatioRegion], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy], 
        (
            SELECT dbo.[F_GetOriginValue](@Vehicle, GETDATE())
        ) OriginValue, 
        (
            SELECT dbo.[F_GetNetAssetValue](@Vehicle, GETDATE())
        ) NetAssetValue
        FROM [tbl_VehicleRatio]
        WHERE VehicleID = ISNULL(@Vehicle, VehicleID);
    END;
