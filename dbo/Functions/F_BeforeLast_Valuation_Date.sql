CREATE FUNCTION [dbo].[F_BeforeLast_Valuation_Date]
(@vehicleid   INT, 
 @portfolioid INT, 
 @Date        DATETIME
)
RETURNS DATETIME
AS
     BEGIN
         DECLARE @beforelastvalue DATETIME;
         DECLARE @temp TABLE
         (InvestmentDate DATETIME, 
          Date           DATETIME
         );
         INSERT INTO @temp
                SELECT TOP 2 pv.Date, 
                             date
                FROM tbl_PortfolioValuation pv
                WHERE pv.vehicleid = @vehicleid
                      AND portfolioid = @portfolioid
                      AND DATE <= @Date
                ORDER BY pv.date DESC;
         SELECT @beforelastvalue =
         (
             SELECT TOP 1 InvestmentDate
             FROM @temp
         );
         RETURN @beforelastvalue;
     END; 
