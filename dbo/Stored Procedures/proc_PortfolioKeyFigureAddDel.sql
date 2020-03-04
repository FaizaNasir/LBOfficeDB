CREATE PROC [dbo].[proc_PortfolioKeyFigureAddDel]
(@portfolioID INT, 
 @TargetID    INT, 
 @isAdd       BIT, 
 @isNext      BIT, 
 @subTabID    INT, 
 @date        DATETIME
)
AS
     DECLARE @year DATETIME;
     DECLARE @count INT;
     DECLARE @current INT;
     DECLARE @id INT;
    BEGIN
        IF @isAdd = 1
           AND @isNext = 1
            BEGIN
                SET @year =
                (
                    SELECT DATEADD(year, 1, MAX(year))
                    FROM tbl_portfoliokeyfigure a
                    WHERE a.portfolioID = @portfolioID
                          AND TargetPortfolioID = @TargetID
                          AND date = @date
                );
                INSERT INTO tbl_portfoliokeyfigure
                (PortfolioID, 
                 TargetPortfolioID, 
                 KeyFigureConfigID, 
                 Year, 
                 SubTab, 
                 date
                )
                       SELECT @portfolioID, 
                              @TargetID, 
                              KeyFigureConfigID, 
                              @year, 
                              @subTabID, 
                              @date
                       FROM tbl_KeyfigureConfig
                       WHERE Portfolioid = @PortfolioID
                             AND date = @date;
        END;
            ELSE
            IF @isAdd = 1
               AND @isNext = 0
                BEGIN
                    SET @year =
                    (
                        SELECT DATEADD(year, -1, MIN(year))
                        FROM tbl_portfoliokeyfigure a
                        WHERE a.portfolioID = @portfolioID
                              AND TargetPortfolioID = @TargetID
                              AND date = @date
                    );
                    INSERT INTO tbl_portfoliokeyfigure
                    (PortfolioID, 
                     TargetPortfolioID, 
                     KeyFigureConfigID, 
                     Year, 
                     SubTab, 
                     date
                    )
                           SELECT @portfolioID, 
                                  @TargetID, 
                                  KeyFigureConfigID, 
                                  @year, 
                                  @subTabID, 
                                  date
                           FROM tbl_KeyfigureConfig
                           WHERE Portfolioid = @PortfolioID
                                 AND date = @date;
            END;
                ELSE
                IF @isAdd = 0
                   AND @isNext = 1
                    BEGIN
                        DELETE FROM tbl_portfoliokeyfigure
                        WHERE PortfolioID = @portfolioID
                              AND SubTab = @subTabID
                              AND date = @date
                              AND TargetPortfolioID = @TargetID
                              AND YEAR(year) =
                        (
                            SELECT MAX(YEAR(year))
                            FROM tbl_portfoliokeyfigure a
                            WHERE a.portfolioID = @portfolioID
                                  AND TargetPortfolioID = @TargetID
                                  AND date = @date
                                  AND SubTab = @subTabID
                        );
                END;
                    ELSE
                    IF @isAdd = 0
                       AND @isNext = 0
                        BEGIN
                            DELETE FROM tbl_portfoliokeyfigure
                            WHERE PortfolioID = @portfolioID
                                  AND date = @date
                                  AND SubTab = @subTabID
                                  AND TargetPortfolioID = @TargetID
                                  AND YEAR(year) =
                            (
                                SELECT MIN(YEAR(year))
                                FROM tbl_portfoliokeyfigure a
                                WHERE a.portfolioID = @portfolioID
                                      AND TargetPortfolioID = @TargetID
                                      AND date = @date
                                      AND SubTab = @subTabID
                            );
                    END;
        SELECT 1;
    END;
