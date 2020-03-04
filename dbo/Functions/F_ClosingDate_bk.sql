
-- select dbo.[F_Last_Valuation](28,11,GETDATE())    

CREATE FUNCTION [dbo].[F_ClosingDate_bk]
(@vehicleid   INT, 
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
             WHERE pso.ToID = @vehicleid
                   AND pso.PortfolioID = @portfolioid
                   AND pso.ToTypeID = 3
             ORDER BY Date
         );

         --(Select top 1 InvestmentValue from @temp              
         --  order by date asc)              

         RETURN @beforelastvalue;
     END; 
