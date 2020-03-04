--  select  dbo.F_F_GetNetFinancialDebt  

CREATE FUNCTION [dbo].[F_GetNetFinancialDebt]
(@PortfolioID INT
)
RETURNS DECIMAL(18, 6)
AS
     BEGIN
         DECLARE @result DECIMAL(18, 6);
         SET @result =
         (
             SELECT TOP 1 CAST(Amount AS DECIMAL(18, 6))
             FROM tbl_PortfolioKeyFigure pkf
                  JOIN tbl_KeyFigureConfig kfc ON kfc.KeyFigureConfigID = pkf.KeyFigureConfigID
             WHERE kfc.Name = 'Net financial debt'
                   AND pkf.portfolioid = @PortfolioID
                   AND YEAR(Year) IN
             (
                 SELECT TOP 1 YEAR(year)
                 FROM tbl_PortfolioKeyFigure pkf
                      JOIN tbl_KeyFigureConfig kfc ON kfc.KeyFigureConfigID = pkf.KeyFigureConfigID
                 WHERE pkf.portfolioid = @PortfolioID
                       AND kfc.Name = 'Category'
                       AND amount NOT IN('E', 'B')
                 ORDER BY pkf.KeyFIgureID DESC
             )
             ORDER BY pkf.KeyFIgureID DESC
         );
         RETURN ISNULL(@result, 0);
     END;
