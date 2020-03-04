--  select dbo.[F_CapitalTable_LastTurnoverN-1](581)        

CREATE FUNCTION [dbo].[F_CapitalTable_LastTurnoverN-2]
(@CompanyID INT
)
RETURNS DECIMAL(18, 3)
AS
     BEGIN
         DECLARE @return_value DECIMAL(18, 3);
         SET @return_value =
         (
             SELECT TOP 1 Amount
             FROM tbl_PortfolioKeyFigure b
                  JOIN tbl_KeyfigureConfig c ON b.KeyFigureConfigID = c.KeyFigureConfigID
             WHERE b.TargetPortfolioID = @CompanyID
                   AND YEAR(year) IN
             (
                 SELECT TOP 3 YEAR(year)
                 FROM tbl_PortfolioKeyFigure b
                      JOIN tbl_KeyfigureConfig c ON b.KeyFigureConfigID = c.KeyFigureConfigID
                 WHERE c.name = 'Category'
                       AND b.TargetPortfolioID = @CompanyID
                       AND b.subtab = 1
                 ORDER BY YEAR DESC
             )
                 AND b.subtab = 1
                 AND c.name = 'Revenues'
             ORDER BY YEAR(year) ASC
         );
         RETURN @return_value;
     END; 
