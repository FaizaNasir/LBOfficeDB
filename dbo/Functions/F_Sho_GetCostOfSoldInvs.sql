
--  select dbo.[F_Sho_GetCostOfSoldInvs](null,44,null,1)    

CREATE FUNCTION [dbo].[F_Sho_GetCostOfSoldInvs]
(@sho         SHOTYPE READONLY, 
 @portfolioID INT, 
 @NatureID    INT, 
 @typeID      INT, 
 @VehicleID   INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @CostOfSold DECIMAL(18, 2);
         SELECT @CostOfSold = SUM(Number)
         FROM
         (
             SELECT(SUM(Amount) / SUM(Number)) * ISNULL(
             (
                 SELECT SUM(Number)
                 FROM @sho a
                 WHERE a.SecurityID = b.SecurityID
                       AND FromTypeID = 3
                       AND Date < DATEADD(year, -2, GETDATE())
             ), 0) Number
             FROM @sho b
             WHERE FromTypeID <> 3
                   AND NatureID = ISNULL(@NatureID, NatureID)
                   AND 1 = CASE
                               WHEN @typeID = 1
                               THEN 1
                               WHEN @typeID = 2
                                    AND PortfolioID IN
             (
                 SELECT ObjectModuleID
                 FROM tbl_eligibility
                 WHERE moduleID = 7
                       AND ObjectModuleID = ISNULL(NULL, ObjectModuleID)
                       AND IsCapital = 1
                       AND vehicleID = @VehicleID
             )
                               THEN 1
                               WHEN @typeID = 3
                                    AND PortfolioID IN
             (
                 SELECT ObjectModuleID
                 FROM tbl_eligibility
                 WHERE moduleID = 7
                       AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                       AND IsCompanylessthan5Years = 1
                       AND vehicleID = @VehicleID
             )
                               THEN 1
                               WHEN @typeID = 4
                                    AND PortfolioID IN
             (
                 SELECT ObjectModuleID
                 FROM tbl_eligibility
                 WHERE moduleID = 7
                       AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                       AND IsCompanylessthan8Years = 1
                       AND vehicleID = @VehicleID
             )
                               THEN 1
                               WHEN @typeID = 5
                                    AND PortfolioID IN
             (
                 SELECT ObjectModuleID
                 FROM tbl_eligibility
                 WHERE moduleID = 7
                       AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                       AND QuotationID = 2
                       AND vehicleID = @VehicleID
             )
                               THEN 1
                               WHEN @typeID = 6
                                    AND PortfolioID IN
             (
                 SELECT ObjectModuleID
                 FROM tbl_eligibility
                 WHERE moduleID = 7
                       AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                       AND QuotationID = 3
                       AND vehicleID = @VehicleID
             )
                               THEN 1
                               WHEN @typeID = 7
                                    AND PortfolioID IN
             (
                 SELECT ObjectModuleID
                 FROM tbl_eligibility
                 WHERE moduleID = 7
                       AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                       AND NatureID = 1
             )
                               THEN 1
                               WHEN @typeID = 8
                                    AND PortfolioID IN
             (
                 SELECT ObjectModuleID
                 FROM tbl_eligibility
                 WHERE moduleID = 7
                       AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                       AND NatureID = 2
                       AND vehicleID = @VehicleID
             )
                               THEN 1
                               WHEN @typeID = 9
                                    AND PortfolioID IN
             (
                 SELECT ObjectModuleID
                 FROM tbl_eligibility
                 WHERE moduleID = 7
                       AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                       AND NatureID = 3
                       AND vehicleID = @VehicleID
             )
                               THEN 1
                               WHEN @typeID = 10
                                    AND PortfolioID IN
             (
                 SELECT ObjectModuleID
                 FROM tbl_eligibility
                 WHERE moduleID = 7
                       AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                       AND NatureID = 4
                       AND vehicleID = @VehicleID
             )
                               THEN 1
                           END
             GROUP BY SecurityID
         ) t;
         RETURN @CostOfSold;
     END;
