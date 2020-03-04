--  select dbo.[F_CapitalTable_LastTurnover](705)                

CREATE FUNCTION [dbo].[F_CapitalTable_LastFCF]
(@CompanyID INT
)
RETURNS DECIMAL(18, 3)
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
         SET @return_value =
         (
             SELECT Amount
             FROM tbl_PortfolioKeyFigure b
                  JOIN tbl_KeyfigureConfig c ON b.KeyFigureConfigID = c.KeyFigureConfigID
             WHERE b.TargetPortfolioID = @CompanyID
                   AND @year = YEAR(year)
                   AND Amount IS NOT NULL
                   AND b.subtab = 1
                   AND c.name = 'Free cash flows'
         );
         RETURN @return_value;
     END; 
