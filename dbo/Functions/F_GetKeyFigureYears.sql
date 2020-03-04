CREATE FUNCTION [dbo].[F_GetKeyFigureYears]
(@portfolioID INT, 
 @year        INT
)
RETURNS VARCHAR(1000)
AS
     BEGIN
         DECLARE @EBITDA VARCHAR(1000);
         SET @EBITDA =
         (
             SELECT TOP 1 YEAR(YEAR)
             FROM tbl_PortfolioKeyFigure kf
             WHERE kf.PortfolioID = @portfolioID
                   AND YEAR(YEAR) =
             (
                 SELECT TOP 1 YEAR(year)
                 FROM tbl_PortfolioKeyFigure kfy
                 WHERE kfy.PortfolioID = @portfolioID
                 ORDER BY YEAR(year) DESC
             ) - @year
         );
         RETURN ISNULL(@EBITDA, '');
     END;
