CREATE FUNCTION [dbo].[F_BeforeLast_Valuation_Note]
(@vehicleid   INT, 
 @portfolioid INT, 
 @Date        DATETIME
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @beforelastvalue VARCHAR(MAX);
         DECLARE @temp TABLE
         (InvestmentNote VARCHAR(MAX), 
          Date           DATETIME
         );
         INSERT INTO @temp
                SELECT TOP 2 pv.Notes, 
                             date
                FROM tbl_PortfolioValuation pv
                WHERE pv.vehicleid = @vehicleid
                      AND portfolioid = @portfolioid
                      AND DATE <= @Date
                ORDER BY pv.date DESC;
         SELECT @beforelastvalue =
         (
             SELECT TOP 1 InvestmentNote
             FROM @temp
             ORDER BY date ASC
         );
         RETURN @beforelastvalue;
     END; 
