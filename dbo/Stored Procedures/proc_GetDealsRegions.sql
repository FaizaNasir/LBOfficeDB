
-- proc_GetFundsRegions '1'

CREATE PROC [dbo].[proc_GetDealsRegions]
(@dealID   INT, 
 @regionID INT = NULL
)
AS
    BEGIN
        SELECT DISTINCT 
               r.RegionID, 
               r.RegionName
        FROM tbl_Eligibility e
             JOIN tbl_EligibilityRegion er ON e.EligibilityID = er.EligibilityID
             JOIN tbl_region r ON r.RegionID = er.RegionID
        WHERE e.ObjectModuleID = @dealID
              AND moduleID = 6
              AND r.RegionID = ISNULL(@regionID, r.RegionID);
    END;
