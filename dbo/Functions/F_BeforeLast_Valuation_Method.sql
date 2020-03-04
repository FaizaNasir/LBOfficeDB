CREATE FUNCTION [dbo].[F_BeforeLast_Valuation_Method]
(@vehicleid   INT, 
 @portfolioid INT, 
 @Date        DATETIME
)
RETURNS VARCHAR(1000)
AS
     BEGIN
         DECLARE @beforelastvalue VARCHAR(1000);
         DECLARE @temp TABLE
         (InvestmentMethod VARCHAR(1000), 
          Date             DATETIME
         );
         INSERT INTO @temp
                SELECT TOP 2 pvm.ValuationMethodName, 
                             date
                FROM tbl_PortfolioValuation pv
                     INNER JOIN tbl_PortfolioValuationMethod pvm ON pvm.ValuationMethodID = pv.MethodID
                WHERE pv.vehicleid = @vehicleid
                      AND portfolioid = @portfolioid
                      AND DATE <= @Date
                ORDER BY pv.date ASC;
         SELECT @beforelastvalue =
         (
             SELECT TOP 1 InvestmentMethod
             FROM @temp
             ORDER BY date ASC
         );
         RETURN @beforelastvalue;
     END;   
