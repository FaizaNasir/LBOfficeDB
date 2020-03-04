-- FundReport_KeyFigure 57,'12-31-2016'

CREATE PROC [dbo].[FundReport_KeyFigure]
(@portfolioID INT, 
 @date        DATETIME
)
AS
    BEGIN
        DECLARE @RevenuesN_2 DECIMAL(18, 6);
        DECLARE @EBITDAN_2 DECIMAL(18, 6);
        DECLARE @EnterpriseValueN_2 DECIMAL(18, 6);
        DECLARE @RevenuesN_1 DECIMAL(18, 6);
        DECLARE @EBITDAN_1 DECIMAL(18, 6);
        DECLARE @EnterpriseValueN_1 DECIMAL(18, 6);
        SET @RevenuesN_1 =
        (
            SELECT TOP 1 amount
            FROM tbl_PortfolioKeyFigure kf
                 JOIN tbl_keyfigureconfig kfc ON kfc.KeyFigureConfigID = kf.KeyFigureConfigID
            WHERE kf.portfolioid = @portfolioid
                  AND kfc.Name = 'Revenues'
                  AND YEAR(kf.Year) = YEAR(@date)
        );
        SET @EBITDAN_1 =
        (
            SELECT TOP 1 amount
            FROM tbl_PortfolioKeyFigure kf
                 JOIN tbl_keyfigureconfig kfc ON kfc.KeyFigureConfigID = kf.KeyFigureConfigID
            WHERE kf.portfolioid = @portfolioid
                  AND kfc.Name = 'EBITDA'
                  AND YEAR(kf.Year) = YEAR(@date)
        );
        SET @EnterpriseValueN_1 =
        (
            SELECT TOP 1 amount
            FROM tbl_PortfolioKeyFigure kf
                 JOIN tbl_keyfigureconfig kfc ON kfc.KeyFigureConfigID = kf.KeyFigureConfigID
            WHERE kf.portfolioid = @portfolioid
                  AND kfc.Name = 'Enterprise value'
                  AND YEAR(kf.Year) = YEAR(@date)
        );
        SET @RevenuesN_2 =
        (
            SELECT TOP 1 amount
            FROM tbl_PortfolioKeyFigure kf
                 JOIN tbl_keyfigureconfig kfc ON kfc.KeyFigureConfigID = kf.KeyFigureConfigID
            WHERE kf.portfolioid = @portfolioid
                  AND kfc.Name = 'Revenues'
                  AND YEAR(kf.Year) = YEAR(@date) - 1
        );
        SET @EBITDAN_2 =
        (
            SELECT TOP 1 amount
            FROM tbl_PortfolioKeyFigure kf
                 JOIN tbl_keyfigureconfig kfc ON kfc.KeyFigureConfigID = kf.KeyFigureConfigID
            WHERE kf.portfolioid = @portfolioid
                  AND kfc.Name = 'Enterprise value'
                  AND YEAR(kf.Year) = YEAR(@date) - 1
        );
        SET @EnterpriseValueN_2 =
        (
            SELECT TOP 1 amount
            FROM tbl_PortfolioKeyFigure kf
                 JOIN tbl_keyfigureconfig kfc ON kfc.KeyFigureConfigID = kf.KeyFigureConfigID
            WHERE kf.portfolioid = @portfolioid
                  AND kfc.Name = 'Revenues'
                  AND YEAR(kf.Year) = YEAR(@date) - 1
        );
        SELECT @RevenuesN_1 RevenuesN_1, 
               @EBITDAN_1 EBITDAN_1, 
               @EnterpriseValueN_1 EnterpriseValueN_1, 
               @RevenuesN_2 RevenuesN_2, 
               @EBITDAN_2 EBITDAN_2, 
               @EnterpriseValueN_2 EnterpriseValueN_2, 
               YEAR(@date) - 2 YearN_2, 
               YEAR(@date) - 1 YearN_1;
    END;
