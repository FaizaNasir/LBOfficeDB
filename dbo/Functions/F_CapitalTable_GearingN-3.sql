--  select dbo.[F_CapitalTable_LastTurnoverN-2](581)            

CREATE FUNCTION [dbo].[F_CapitalTable_GearingN-3]
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
             WHERE TargetPortfolioID = @CompanyID
                   AND YEAR(year) IN
             (
                 SELECT TOP 4 YEAR(year)
                 FROM tbl_PortfolioKeyFigure b
                      JOIN tbl_KeyfigureConfig c ON b.KeyFigureConfigID = c.KeyFigureConfigID
                 WHERE name = 'Category'
                       AND TargetPortfolioID = @CompanyID
                       AND b.subtab = 1
                 ORDER BY YEAR DESC
             )
                 AND b.subtab = 1
                 AND name = 'Net Debt'
             ORDER BY YEAR(year) ASC
         );
         RETURN @return_value;
     END; 
