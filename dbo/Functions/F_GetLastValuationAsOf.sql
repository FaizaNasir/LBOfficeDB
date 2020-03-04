CREATE FUNCTION [dbo].[F_GetLastValuationAsOf]
(@PortfolioID INT, 
 @vehicleID   INT, 
 @date        DATETIME
)
RETURNS DECIMAL(18, 6)
AS
     BEGIN
         DECLARE @valuation DECIMAL(18, 6);
         SET @valuation = ISNULL(
         (
             SELECT TOP 1 FinalValuation
             FROM tbl_portfoliovaluation pv
             WHERE pv.PortfolioID = @PortfolioID
                   AND pv.VehicleID = @VehicleID
                   AND pv.Date <= @date
             ORDER BY pv.Date DESC
         ), 0);
         RETURN ISNULL(@valuation, 0);
     END;
