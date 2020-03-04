CREATE FUNCTION [dbo].[F_GetKeyFigureValue]
(@portfolioID INT, 
 @name        VARCHAR(100), 
 @year        INT
)
RETURNS VARCHAR(1000)
AS
     BEGIN
         DECLARE @EBITDA VARCHAR(1000);
         SET @EBITDA =
         (
             SELECT TOP 1 Amount
             FROM tbl_PortfolioKeyFigure kf
                  JOIN tbl_KeyfigureConfig kfc ON kfc.KeyFigureConfigID = kf.KeyFigureConfigID
             WHERE kf.PortfolioID = @portfolioID
                   AND YEAR(YEAR) =
             (
                 SELECT TOP 1 YEAR(year)
                 FROM tbl_PortfolioKeyFigure kfy
                 WHERE kfy.PortfolioID = @portfolioID
                 ORDER BY YEAR(year) DESC
             ) - @year
                   AND replace(Name, '''', ' ') LIKE @name
         );
         RETURN ISNULL(replace(@EBITDA, '''', ''), '');
     END;
