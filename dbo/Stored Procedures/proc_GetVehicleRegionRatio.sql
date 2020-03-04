--tbl_portfolioSecurity      
--dbo.tbl_PortfolioSecurityType      
-- tbl_vehicleRatio      
-- proc_GetVehicleRegionRatio 25    

CREATE PROC [dbo].[proc_GetVehicleRegionRatio](@vehicleID INT)
AS
     DECLARE @sho AS SHOTYPE;
     DECLARE @originVal DECIMAL(18, 6);

     --select * from dbo.[F_CheckEligibility](@vehicleID)      

     INSERT INTO @sho
            SELECT ShareholdingOperationID, 
                   PortfolioID, 
                   Date, 
                   Amount, 
                   SecurityID, 
                   Number, 
                   FromID, 
                   ToID, 
                   FromTypeID, 
                   ToTypeID, 
                   NatureID
            FROM tbl_portfolioShareHoldingOperations
            WHERE 1 = (CASE
                           WHEN FromTypeID = 3
                                AND FromID = @vehicleID
                           THEN 1
                           WHEN ToTypeID = 3
                                AND ToID = @vehicleID
                           THEN 1
                       END)
                  AND PortfolioID IN
            (
                SELECT *
                FROM dbo.[F_CheckEligibility](@vehicleID)
            );
     SET @originVal =
     (
         SELECT AssetsofOrigin
         FROM tbl_VehicleShare
         WHERE vehicleID = @vehicleID
     );
     SELECT x.RegionID, 
            r.RegionName, 
            ((
     (
         SELECT SUM(Amount)
         FROM @sho a
              JOIN tbl_eligibility b ON a.portfolioID = b.objectModuleID
                                        AND ModuleID = 7
              JOIN tbl_eligibilityregion c ON c.EligibilityID = b.EligibilityID
                                              AND c.RegionID = x.RegionID
         WHERE b.vehicleid = @vehicleID
               AND a.toid = @vehicleID
     ) - ISNULL(
     (
         SELECT SUM(Amount)
         FROM tbl_portfolioShareHoldingOperations sho
              INNER JOIN tbl_PortfolioSecurity ps ON sho.SecurityID = ps.PortfolioSecurityID
              INNER JOIN tbl_PortfolioSecurityType pst ON ps.PortfolioSecurityTypeID = pst.PortfolioSecurityTypeID
              JOIN tbl_eligibility b ON sho.portfolioID = b.objectModuleID
                                        AND ModuleID = 7
              JOIN tbl_eligibilityregion c ON c.EligibilityID = b.EligibilityID
                                              AND c.RegionID = x.RegionID
         WHERE sho.ToTypeID = 3
               AND sho.ToID = @vehicleID
               AND pst.PortfolioSecurityTypeID = 5
               AND b.vehicleid = @vehicleID
     ), 0) - dbo.[F_GetVehicleRegionRatio](@sho, @vehicleID, x.RegionID, GETDATE())) / @originVal) * 100 AS Ratio
     FROM tbl_vehicleEligibility a
          JOIN tbl_vehicleEligibilityRegion x ON a.VehicleEligibilityID = x.VehicleEligibilityID
          JOIN tbl_region r ON r.RegionID = x.RegionID
     WHERE a.VehicleID = @VehicleID;
