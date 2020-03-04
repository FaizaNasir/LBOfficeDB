CREATE PROCEDURE [dbo].[proc_EligibilityRegion_GET] @EligibilityID INT = NULL
AS
    BEGIN
        SELECT [EligibilityRegionID], 
               [EligibilityID], 
               [RegionID], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM tbl_EligibilityRegion
        WHERE EligibilityID = @EligibilityID;
    END;
