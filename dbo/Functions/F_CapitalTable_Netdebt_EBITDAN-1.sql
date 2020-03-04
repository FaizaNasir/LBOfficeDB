--  select dbo.[F_CapitalTable_LastNetProfitN-1](581)          

CREATE FUNCTION [dbo].[F_CapitalTable_Netdebt/EBITDAN-1]
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
                 SELECT TOP 2 YEAR(year)
                 FROM tbl_PortfolioKeyFigure b
                      JOIN tbl_KeyfigureConfig c ON b.KeyFigureConfigID = c.KeyFigureConfigID
                 WHERE name = 'Category'
                       AND TargetPortfolioID = @CompanyID
                       AND b.subtab = 1
                 ORDER BY YEAR DESC
             )
                 AND b.subtab = 1
                 AND name = 'Financial debt (LT debt)'
         );
         RETURN @return_value;
     END; 
