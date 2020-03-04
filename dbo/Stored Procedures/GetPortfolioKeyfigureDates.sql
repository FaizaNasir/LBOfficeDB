CREATE PROC [dbo].[GetPortfolioKeyfigureDates](@portfolioID INT)
AS
    BEGIN
        SELECT DISTINCT 
               date
        FROM tbl_PortfolioKeyFigure
        WHERE portfolioid = @portfolioID
        ORDER BY date DESC;
    END;
