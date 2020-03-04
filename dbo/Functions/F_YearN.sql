--  select dbo.[F_CapitalTable_LastTurnover](705)              

CREATE FUNCTION [dbo].[F_YearN]
(@CompanyID INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @year INT;
         DECLARE @return_value DECIMAL(18, 3);
         SET @year =
         (
             SELECT TOP 1 YEAR(year)
             FROM tbl_PortfolioKeyFigure b
                  JOIN tbl_KeyfigureConfig c ON b.KeyFigureConfigID = c.KeyFigureConfigID
             WHERE c.name = 'Category'
                   AND b.TargetPortfolioID = @CompanyID
                   AND b.subtab = 1
             ORDER BY YEAR DESC
         );

         --set @return_value = (  select Amount from               
         -- tbl_PortfolioKeyFigure  b      
         -- join tbl_KeyfigureConfig c on b.KeyFigureConfigID=c.KeyFigureConfigID          
         -- where TargetPortfolioID = @CompanyID              
         -- and @year  = Year(b.year)        
         -- and Amount is not null          
         -- and b.subtab = 1              
         --and name = 'Revenues')             

         RETURN @year;
     END; 
