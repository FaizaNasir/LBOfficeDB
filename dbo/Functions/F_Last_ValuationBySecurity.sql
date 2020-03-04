-- select dbo.[F_Last_Valuation](66,60,GETDATE())        

CREATE FUNCTION [dbo].[F_Last_ValuationBySecurity]
(@vehicleid   INT, 
 @portfolioid INT, 
 @Date        DATETIME, 
 @securityid  INT
)
RETURNS DECIMAL(18, 2)
AS
     BEGIN
         DECLARE @beforelastvalue DECIMAL(18, 2);
         SELECT @beforelastvalue =
         (
             SELECT TOP 1 CAST(ISNULL(Value, 0) AS DECIMAL(18, 2))
             FROM tbl_PortfolioValuation pv
                  JOIN tbl_PortfolioValuationDetails pvd ON pvd.ValuationID = pv.ValuationID
             WHERE pv.vehicleid = @vehicleid
                   AND pvd.SecurityID = @securityid
                   AND portfolioid = @portfolioid
                   AND DATE <= @Date
             ORDER BY date DESC
         );
         RETURN @beforelastvalue;
     END;
