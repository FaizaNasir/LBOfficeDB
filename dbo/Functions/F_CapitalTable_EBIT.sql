--  select dbo.[F_CapitalTable_Turnover](581)  

CREATE FUNCTION [dbo].[F_CapitalTable_EBIT]
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
             FROM tbl_PortfolioKeyFigure
             WHERE name = 'Category'
                   AND TargetPortfolioID = @CompanyID
                   AND subtab = 1
                   AND ISNULL(amount, 'A') <> 'B'
                   AND ISNULL(amount, 'A') <> 'E'
             ORDER BY YEAR DESC
         );
         SET @return_value =
         (
             SELECT Amount
             FROM tbl_PortfolioKeyFigure
             WHERE TargetPortfolioID = @CompanyID
                   AND YEAR(year) = @year
                   AND subtab = 1
                   AND Name = 'EBIT'
         );
         RETURN @return_value;
     END;
