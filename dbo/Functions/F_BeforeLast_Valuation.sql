
--  select  dbo.[F_BeforeLast_Valuation](66,60,'12-31-2016')      

CREATE FUNCTION [dbo].[F_BeforeLast_Valuation]
(@vehicleid   INT, 
 @portfolioid INT, 
 @Date        DATETIME
)
RETURNS INT
AS
     BEGIN
         DECLARE @beforelastvalue INT;
         DECLARE @temp TABLE
         (InvestmentValue INT, 
          Date            DATETIME
         );
         INSERT INTO @temp
                SELECT TOP 2 CASE
                                 WHEN pv.Discount <> 0
                                 THEN pv.FinalValuation
                                 ELSE InvestmentValue
                             END, 
                             date
                FROM tbl_PortfolioValuation pv
                WHERE pv.vehicleid = @vehicleid
                      AND portfolioid = @portfolioid
                      AND DATE <= @Date
                ORDER BY date DESC;
         SELECT @beforelastvalue =
         (
             SELECT TOP 1 InvestmentValue
             FROM @temp
         );
         RETURN @beforelastvalue;
     END; 
