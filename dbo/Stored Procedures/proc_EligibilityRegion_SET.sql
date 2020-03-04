CREATE PROCEDURE [dbo].[proc_EligibilityRegion_SET] @EligibilityID    INT          = NULL, 
                                                    @RegionID         INT          = NULL, 
                                                    @Active           BIT          = NULL, 
                                                    @CreatedDateTime  DATETIME     = NULL, 
                                                    @ModifiedDateTime DATETIME     = NULL, 
                                                    @CreatedBy        VARCHAR(100) = NULL, 
                                                    @ModifiedBy       VARCHAR(100) = NULL
AS
     DECLARE @EligibilityRegionID INT= NULL;
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM tbl_EligibilityRegion
            WHERE EligibilityID = @EligibilityID
        )
            BEGIN
                INSERT INTO [tbl_EligibilityRegion]
                (EligibilityID, 
                 RegionID, 
                 Active, 
                 CreatedDateTime, 
                 ModifiedDateTime, 
                 CreatedBy, 
                 ModifiedBy
                )
                VALUES
                (@EligibilityID, 
                 @RegionID, 
                 @Active, 
                 @CreatedDateTime, 
                 @ModifiedDateTime, 
                 @CreatedBy, 
                 @ModifiedBy
                );
        END;
        SET @EligibilityRegionID = @@IDENTITY;
        SELECT 'SUCESS' AS RESULT, 
               @EligibilityRegionID 'EligibilityRegionID';
    END;
