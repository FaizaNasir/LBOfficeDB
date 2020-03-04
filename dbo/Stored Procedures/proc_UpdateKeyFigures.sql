CREATE PROC [dbo].[proc_UpdateKeyFigures]
(@portfolioID       INT, 
 @TargetPortfolioID INT, 
 @Name              VARCHAR(1000), 
 @year              VARCHAR(1000), 
 @data              VARCHAR(1000), 
 @seq               INT           = NULL, 
 @subTabID          INT, 
 @dateHistory       DATETIME
)
AS
     IF @data = 'CLEAR'
        OR @data = '----'
         SET @data = '';
     DECLARE @KeyFigureConfigID INT;
     SET @KeyFigureConfigID =
     (
         SELECT TOP 1 KeyFigureConfigID
         FROM tbl_KeyfigureConfig
         WHERE PortfolioID = @portfolioID
               AND Name = @Name
               AND date <= @dateHistory
     );
    BEGIN
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioKeyFigure
            WHERE PortfolioID = @portfolioID
                  AND TargetPortfolioID = @TargetPortfolioID
                  AND KeyFigureConfigID = @KeyFigureConfigID
                  AND SubTab = @subTabID
                  AND date = @dateHistory
                  AND YEAR(Year) = YEAR(CAST(@year AS DATETIME))
        )
            BEGIN
                UPDATE tbl_PortfolioKeyFigure
                  SET 
                      amount = ISNULL(@data, amount)
                WHERE PortfolioID = @portfolioID
                      AND TargetPortfolioID = @TargetPortfolioID
                      AND KeyFigureConfigID = @KeyFigureConfigID
                      AND SubTab = @subTabID
                      AND date = @dateHistory
                      AND YEAR(Year) = YEAR(CAST(@year AS DATETIME));
        END;
            ELSE
            BEGIN
                INSERT INTO tbl_PortfolioKeyFigure
                (PortfolioID, 
                 TargetPortfolioID, 
                 KeyFigureConfigID, 
                 Year, 
                 Amount, 
                 SubTab, 
                 Date
                )
                       SELECT @PortfolioID, 
                              @TargetPortfolioID, 
                              @KeyFigureConfigID, 
                              CAST(@year AS DATETIME), 
                              @data, 
                              @subTabID, 
                              @dateHistory;
        END;
        SELECT 1;
    END;  
