CREATE PROCEDURE [dbo].[proc_VehicleEligibilityRegion_SET] @VehicleEligibilityID INT          = NULL, 
                                                           @RegionID             INT          = NULL, 
                                                           @Active               BIT          = NULL, 
                                                           @CreatedDateTime      DATETIME     = NULL, 
                                                           @ModifiedDateTime     DATETIME     = NULL, 
                                                           @CreatedBy            VARCHAR(100) = NULL, 
                                                           @ModifiedBy           VARCHAR(100) = NULL
AS
     DECLARE @VehicleEligibilityRegionID INT= NULL;
    BEGIN
        INSERT INTO [tbl_VehicleEligibilityRegion]
        (VehicleEligibilityID, 
         RegionID, 
         Active, 
         CreatedDateTime, 
         ModifiedDateTime, 
         CreatedBy, 
         ModifiedBy
        )
        VALUES
        (@VehicleEligibilityID, 
         @RegionID, 
         @Active, 
         @CreatedDateTime, 
         @ModifiedDateTime, 
         @CreatedBy, 
         @ModifiedBy
        );
        SET @VehicleEligibilityRegionID = @@IDENTITY;
        SELECT 'SUCESS' AS RESULT, 
               @VehicleEligibilityRegionID 'VehicleEligibilityRegionID';
    END;
