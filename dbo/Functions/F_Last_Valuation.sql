
-- select dbo.[F_Last_Valuation](66,60,GETDATE())        

CREATE FUNCTION [dbo].[F_Last_Valuation]
(@vehicleid   INT, 
 @portfolioid INT, 
 @Date        DATETIME
)
RETURNS DECIMAL(18, 2)
AS
     BEGIN
         DECLARE @beforelastvalue DECIMAL(18, 2);
         SELECT @beforelastvalue =
         (
             SELECT TOP 1 CAST(ISNULL(pv.FinalValuation, 0) AS DECIMAL(18, 2))
             FROM tbl_PortfolioValuation pv
             WHERE pv.vehicleid = @vehicleid
                   AND portfolioid = @portfolioid
                   AND DATE <= @Date
             ORDER BY date DESC
         );
         RETURN @beforelastvalue;
     END;
