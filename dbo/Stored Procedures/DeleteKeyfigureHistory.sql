CREATE PROC [dbo].[DeleteKeyfigureHistory]
(@portfolioID INT, 
 @date        DATETIME
)
AS
    BEGIN
        DELETE FROM tbl_KeyfigureConfig
        WHERE PortfolioID = @portfolioID
              AND CONVERT(VARCHAR(10), date, 103) = CONVERT(VARCHAR(10), @date, 103);
        DELETE FROM tbl_PortfolioKeyFigure
        WHERE PortfolioID = @portfolioID
              AND CONVERT(VARCHAR(10), date, 103) = CONVERT(VARCHAR(10), @date, 103);
        SELECT 1 Result;
    END;
