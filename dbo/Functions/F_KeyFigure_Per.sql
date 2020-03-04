
--  select dbo.[F_KeyFigure_Per]('Turnover_Per',5,580,1,2013)                            
--  select dbo.[F_CapitalTable_LastNetProfit](581)                            

CREATE FUNCTION [dbo].[F_KeyFigure_Per]
(@name              VARCHAR(100), 
 @portfolioID       INT, 
 @targetportfolioID INT, 
 @subTabID          INT, 
 @year              INT
)
RETURNS DECIMAL(18, 2)
AS
     BEGIN
         DECLARE @return_value DECIMAL(18, 3);
         DECLARE @Financialdebt DECIMAL(18, 3);
         DECLARE @Netcash DECIMAL(18, 3);
         DECLARE @EBITDA DECIMAL(18, 3);
         DECLARE @turnOverLast DECIMAL(18, 3);
         DECLARE @Turnover DECIMAL(18, 3);
         IF(@name = 'Net_debt_Per')
             BEGIN
                 SET @Financialdebt =
                 (
                     SELECT SUM(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 3)))
                     FROM tbl_PortfolioKeyFigure
                     WHERE PortfolioID = @portfolioID
                           AND YEAR(YEAR) = @year
                           AND TargetPortfolioID = @TargetPortfolioID
                           AND Name = 'Financial Debt(LT)'
                           AND Amount IS NOT NULL
                           AND SubTab = @subTabID
                 );
                 SET @Netcash =
                 (
                     SELECT SUM(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 3)))
                     FROM tbl_PortfolioKeyFigure
                     WHERE PortfolioID = @portfolioID
                           AND YEAR(YEAR) = @year
                           AND TargetPortfolioID = @TargetPortfolioID
                           AND Amount IS NOT NULL
                           AND Name = 'Net Cash - (ST Debt)'
                           AND SubTab = @subTabID
                 );
                 SET @EBITDA =
                 (
                     SELECT SUM(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 3)))
                     FROM tbl_PortfolioKeyFigure
                     WHERE PortfolioID = @portfolioID
                           AND YEAR(YEAR) = @year
                           AND TargetPortfolioID = @TargetPortfolioID
                           AND Name = 'EBITDA'
                           AND Amount IS NOT NULL
                           AND SubTab = @subTabID
                 );
                 IF @EBITDA IS NOT NULL
                    AND CAST(@EBITDA AS DECIMAL(18, 3)) <> 0
                    AND @Financialdebt IS NOT NULL
                    AND @Netcash IS NOT NULL
                    AND @Netcash IS NOT NULL
                     BEGIN
                         SET @return_value = (ISNULL(@Financialdebt, 0) - ISNULL(@Netcash, 0)) / @EBITDA;
                 END;
         END;
             ELSE
             IF(@name = 'Turnover_Per')
                 BEGIN
                     SET @turnOverLast =
                     (
                         SELECT SUM(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 3)))
                         FROM tbl_PortfolioKeyFigure
                         WHERE PortfolioID = @portfolioID
                               AND YEAR(YEAR) = @year - 1
                               AND TargetPortfolioID = @TargetPortfolioID
                               AND Amount IS NOT NULL
                               AND Name = 'Turnover'
                               AND SubTab = 1
                     );
                     SET @Turnover =
                     (
                         SELECT SUM(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 3)))
                         FROM tbl_PortfolioKeyFigure
                         WHERE PortfolioID = @portfolioID
                               AND YEAR(YEAR) = @year
                               AND TargetPortfolioID = @TargetPortfolioID
                               AND Amount IS NOT NULL
                               AND Name = 'Turnover'
                               AND SubTab = 1
                     );
                     IF @turnOverLast IS NOT NULL
                        AND @turnOverLast <> '0'
                        AND @Turnover IS NOT NULL
                        AND @Turnover <> 0
                         BEGIN
                             SET @return_value = 100 * (ISNULL(@Turnover, 0) - CAST(ISNULL(@turnOverLast, 0) AS DECIMAL(18, 3))) / CAST(ISNULL(@turnOverLast, 0) AS DECIMAL(18, 3));             
                             --set @return_value = 1111111111                                              
                     END;
             END;
                 ELSE
                 IF(@name = 'EBITDA_Per')
                     BEGIN
                         SET @Turnover =
                         (
                             SELECT SUM(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 3)))
                             FROM tbl_PortfolioKeyFigure
                             WHERE PortfolioID = @portfolioID
                                   AND YEAR(YEAR) = @year
                                   AND TargetPortfolioID = @TargetPortfolioID
                                   AND Name = 'Turnover'
                                   AND Amount IS NOT NULL
                                   AND SubTab = @subTabID
                         );
                         SET @EBITDA =
                         (
                             SELECT SUM(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 3)))
                             FROM tbl_PortfolioKeyFigure
                             WHERE PortfolioID = @portfolioID
                                   AND YEAR(YEAR) = @year
                                   AND TargetPortfolioID = @TargetPortfolioID
                                   AND Name = 'EBITDA'
                                   AND Amount IS NOT NULL
                                   AND SubTab = @subTabID
                         );
                         IF @Turnover IS NOT NULL
                            AND @Turnover <> '0'
                            AND @EBITDA IS NOT NULL
                             BEGIN
                                 SET @return_value = 100 * @EBITDA / @Turnover;
                         END;
                 END;
         RETURN CASE
                    WHEN @return_value IS NULL
                    THEN @return_value
                    ELSE CAST(SUBSTRING(CAST(ISNULL(@return_value, 0) AS VARCHAR), 1, LEN(CAST(ISNULL(@return_value, 0) AS VARCHAR)) - 1) AS DECIMAL(18, 2))
                END;
     END; 
