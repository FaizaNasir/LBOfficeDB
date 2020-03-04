CREATE PROCEDURE [dbo].[proc_VehicleEligibilityRegion_GET] @VehicleEligibilityID INT = NULL
AS
    BEGIN
        SELECT [VehicleEligibilityRegionID], 
               [VehicleEligibilityID], 
               [RegionID], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM tbl_VehicleEligibilityRegion
        WHERE VehicleEligibilityID = @VehicleEligibilityID;
    END;
