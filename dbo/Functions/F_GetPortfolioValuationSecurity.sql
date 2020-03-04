CREATE FUNCTION [dbo].[F_GetPortfolioValuationSecurity]
(@PortfolioID INT = NULL, 
 @vehicleID   INT, 
 @securityID  INT
)
RETURNS DECIMAL(18, 3)
AS
     BEGIN
         DECLARE @result DECIMAL(18, 6);
         SET @result =
         (
             SELECT SUM(CASE
                            WHEN ToTypeID = 3
                                 AND ToID = @vehicleID
                            THEN Number
                            WHEN FromTypeID = 3
                                 AND FromID = @vehicleID
                            THEN-1 * Number
                        END) Number
             FROM tbl_PortfolioSecurity s
                  JOIN tbl_portfolioshareholdingoperations sho ON sho.portfolioID = s.PortfolioID
                                                                  AND s.PortfolioSecurityID = sho.SecurityID
             WHERE s.PortfolioID = @PortfolioID
                   AND s.PortfolioSecurityID = @securityID
         );
         RETURN @result;
     END;
