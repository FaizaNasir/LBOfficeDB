
--  select dbo.[F_Quartervariation](28,6)          

CREATE FUNCTION [dbo].[F_Quartervariation]
(@vehicleid   INT, 
 @portfolioid INT, 
 @Date        DATETIME
)
RETURNS INT
AS
     BEGIN
         DECLARE @lastvalue INT;
         DECLARE @beforelastvalue INT;
         DECLARE @temp TABLE
         (InvestmentValue INT, 
          Date            DATETIME
         );
         INSERT INTO @temp
                SELECT TOP 2 InvestmentValue, 
                             date
                FROM tbl_PortfolioValuation pv
                WHERE pv.vehicleid = @vehicleid
                      AND portfolioid = @portfolioid
                      AND date <= @Date
                ORDER BY date DESC;
         SELECT @lastvalue =
         (
             SELECT TOP 1 InvestmentValue
             FROM @temp
             ORDER BY date DESC
         );
         SELECT @beforelastvalue =
         (
             SELECT TOP 1 InvestmentValue
             FROM @temp
             ORDER BY date ASC
         );
         RETURN @lastvalue - @beforelastvalue;
     END; 
