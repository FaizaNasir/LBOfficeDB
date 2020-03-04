
-- select dbo.[F_Last_Valuation_ForeginCurrency](28,11,GETDATE())    

CREATE FUNCTION [dbo].[F_Last_Valuation_ForeginCurrency]
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
             SELECT TOP 1 ForeignCurrencyAmount
             FROM tbl_PortfolioValuation pv
             WHERE pv.vehicleid = @vehicleid
                   AND portfolioid = @portfolioid
                   AND DATE <= @Date
             ORDER BY date ASC
         );

         --(Select top 1 InvestmentValue from @temp              
         --  order by date asc)              

         RETURN @beforelastvalue;
     END; 
