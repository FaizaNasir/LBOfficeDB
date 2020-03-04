
--% growth (under revenues) = (Revenues N – Revenues N-1) / Revenues N-1 (in %)
--% growth (under EBITDA) = (EBITDA N – EBITDA N-1) / EBITDA N-1 (in%)

CREATE FUNCTION [dbo].[F_KeyFigure_EBITDAMargin]
(@PortfolioID INT, 
 @year        INT
)
RETURNS VARCHAR(1000)
AS
     BEGIN
         DECLARE @Revenues DECIMAL(18, 6);
         DECLARE @RevenuesN_1 DECIMAL(18, 6);
         SET @Revenues =
         (
             SELECT SUM(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 3)))
             FROM tbl_PortfolioKeyFigure kf
                  JOIN tbl_keyfigureconfig kfc ON kf.KeyFigureConfigID = kfc.KeyFigureConfigID
             WHERE kf.PortfolioID = @portfolioID
                   AND YEAR(YEAR) = @year
                   AND Name = 'EBITDA'
                   AND Amount IS NOT NULL
         );
         SET @RevenuesN_1 =
         (
             SELECT SUM(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 3)))
             FROM tbl_PortfolioKeyFigure kf
                  JOIN tbl_keyfigureconfig kfc ON kf.KeyFigureConfigID = kfc.KeyFigureConfigID
             WHERE kf.PortfolioID = @portfolioID
                   AND YEAR(YEAR) = @year
                   AND Name = 'Revenues'
                   AND Amount IS NOT NULL
         );

         --if ISNULL(@RevenuesN_1,0) = 0 set @RevenuesN_1 = 1

         RETURN CASE
                    WHEN @RevenuesN_1 IS NULL
                    THEN ''
                    ELSE CAST(CAST(100 * ISNULL(@Revenues, 0) / @RevenuesN_1 AS DECIMAL(18, 2)) AS VARCHAR(100)) + '%'
                END;
     END;
