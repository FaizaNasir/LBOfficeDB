--  select  dbo.F_GetEnterpriseValue  

CREATE FUNCTION [dbo].[F_GetEnterpriseValue]
(@PortfolioID INT, 
 @companyID   INT, 
 @vehicleID   INT
)
RETURNS DECIMAL(18, 6)
AS
     BEGIN
         DECLARE @result DECIMAL(18, 6);
         DECLARE @valuation DECIMAL(18, 6);
         SET @valuation = ISNULL(
         (
             SELECT TOP 1 FinalValuation
             FROM tbl_portfoliovaluation pv
             WHERE pv.PortfolioID = @PortfolioID
                   AND pv.VehicleID = @VehicleID
             ORDER BY pv.Date DESC
         ), 0);
         DECLARE @nonDiluted DECIMAL(18, 3);
         SET @nonDiluted = dbo.[F_NonDiluted](@VehicleID, 3, GETDATE(), @PortfolioID);
         SET @result = CASE
                           WHEN @nonDiluted = 0
                           THEN NULL
                           ELSE @valuation * (1 / @nonDiluted)
                       END;
         RETURN ISNULL(@result, 0);
     END;
