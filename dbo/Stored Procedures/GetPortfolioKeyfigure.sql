CREATE PROC [dbo].[GetPortfolioKeyfigure]
(@portfolioID INT, 
 @date        DATETIME
)
AS
    BEGIN
        SELECT kf.KeyFigureConfigID, 
               Year, 
               Amount, 
               KeyFIgureID, 
               TargetPortfolioID, 
               kf.PortfolioID, 
               Name, 
               Seq
        FROM tbl_PortfolioKeyFigure kf
             JOIN tbl_KeyfigureConfig kfc ON kfc.KeyFigureConfigID = kf.KeyFigureConfigID
        WHERE kf.PortfolioID = @portfolioID
              AND YEAR(year) <= YEAR(@date);
    END;
