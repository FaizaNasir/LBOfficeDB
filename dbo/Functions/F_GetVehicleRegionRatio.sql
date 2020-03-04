CREATE FUNCTION [dbo].[F_GetVehicleRegionRatio]
(@sho       SHOTYPE READONLY, 
 @VehicleID INT, 
 @regionID  INT, 
 @Date      DATETIME
)
RETURNS INT
AS
     BEGIN
         DECLARE @CostOfSold DECIMAL(18, 2);
         SELECT @CostOfSold = SUM(Number)
         FROM
         (
             SELECT(SUM(Amount) / CASE
                                      WHEN SUM(Number) = 0
                                      THEN 1
                                      ELSE SUM(Number)
                                  END) * ISNULL(
             (
                 SELECT SUM(Number)
                 FROM @sho a
                 WHERE a.SecurityID = b.SecurityID
                       AND FromTypeID = 3
                       AND Date < DATEADD(year, -2, @Date)
             ), 0) Number
             FROM @sho b
                  JOIN tbl_eligibility e ON b.portfolioID = e.objectModuleID
                                            AND ModuleID = 7
                  JOIN tbl_eligibilityregion c ON c.EligibilityID = e.EligibilityID
                                                  AND c.RegionID = @RegionID
             WHERE FromTypeID <> 3
                   AND e.vehicleid = @VehicleID
             GROUP BY SecurityID
         ) t;
         RETURN @CostOfSold;
     END;
