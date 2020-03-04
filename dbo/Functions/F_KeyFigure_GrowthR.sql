
--  select  dbo.F_GetCostPrice  

CREATE FUNCTION [dbo].[F_KeyFigure_GrowthR]
(@PortfolioID INT, 
 @year        INT, 
 @name        VARCHAR(100)
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
             WHERE kf.PortfolioID = @PortfolioID
                   AND YEAR(YEAR) = @year
                   AND Name = @name
                   AND Amount IS NOT NULL
         );
         SET @RevenuesN_1 =
         (
             SELECT SUM(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 3)))
             FROM tbl_PortfolioKeyFigure kf
                  JOIN tbl_keyfigureconfig kfc ON kf.KeyFigureConfigID = kfc.KeyFigureConfigID
             WHERE kf.PortfolioID = @PortfolioID
                   AND YEAR(YEAR) = @year - 1
                   AND Name = @name
                   AND Amount IS NOT NULL
         );

         --IF ISNULL(@RevenuesN_1, 0) = 0
         --    SET @RevenuesN_1 = 1;

         RETURN CASE
                    WHEN @RevenuesN_1 IS NULL
                    THEN ''
                    ELSE CAST(CAST(100 * (ISNULL(@Revenues, 0) - ISNULL(@RevenuesN_1, 0)) / @RevenuesN_1 AS DECIMAL(18, 2)) AS VARCHAR(100)) + '%'
                END;
     END;
