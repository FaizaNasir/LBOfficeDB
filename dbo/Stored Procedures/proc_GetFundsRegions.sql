
-- proc_GetFundsRegions '1'

CREATE PROC [dbo].[proc_GetFundsRegions](@vehicleID VARCHAR(100))
AS
    BEGIN
        SELECT DISTINCT 
               r.RegionID, 
               r.RegionName
        FROM tbl_vehicleEligibility e
             JOIN tbl_vehicleEligibilityRegion er ON e.VehicleEligibilityID = er.VehicleEligibilityID
             JOIN tbl_region r ON r.RegionID = er.RegionID
        WHERE e.VehicleID IN
        (
            SELECT *
            FROM dbo.SplitCSV(@vehicleID, ',')
        );
    END;
