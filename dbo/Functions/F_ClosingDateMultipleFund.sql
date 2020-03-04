
-- select dbo.[F_ClosingDateMultipleFund]('28,29',11)    

CREATE FUNCTION [dbo].[F_ClosingDateMultipleFund]
(@vehicleid   VARCHAR(MAX), 
 @portfolioid INT
)
RETURNS DATETIME
AS
     BEGIN
         DECLARE @beforelastvalue DATETIME;
         SELECT @beforelastvalue =
         (
             SELECT TOP 1 pso.Date
             FROM tbl_PortfolioShareholdingOperations pso
             WHERE pso.ToID IN
             (
                 SELECT *
                 FROM dbo.[SplitCSV](@vehicleid, ',')
             )
             AND pso.PortfolioID = @portfolioid
             AND pso.ToTypeID = 3
             ORDER BY Date
         );

         --(Select top 1 InvestmentValue from @temp              
         --  order by date asc)              

         RETURN @beforelastvalue;
     END; 
