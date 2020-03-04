CREATE PROC [dbo].[proc_PortfolioFundKeyFigureAddDel]
(@PortfolioFundUnderlyingInvestmentsID INT, 
 @targetID                             INT, 
 @isAdd                                BIT, 
 @isNext                               BIT, 
 @subTabID                             INT, 
 @date                                 DATETIME
)
AS
     DECLARE @year DATETIME;
     DECLARE @count INT;
     DECLARE @current INT;
     DECLARE @id INT;
    BEGIN

        --Add a row after
        IF @isAdd = 1
           AND @isNext = 1
            BEGIN
                SET @year =
                (
                    SELECT DATEADD(year, 1, MAX(year))
                    FROM tbl_portfolioFundkeyfigure a
                    WHERE a.PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                          --AND date = @date
                          AND YEAR(year) <> '1900'-- don't select closing year (year = 1900)
                );
                INSERT INTO tbl_portfolioFundkeyfigure
                (PortfolioFundUnderlyingInvestmentsID, 
                 VehicleID, 
                 PortfolioFundKeyfigureConfigID, 
                 Year, 
                 SubTab,
                 --date,
                 Type
                )
                       SELECT @PortfolioFundUnderlyingInvestmentsID, 
                              @TargetID, 
                              PortfolioFundKeyfigureConfigID, 
                              @year, 
                              @subTabID,
                              --@date,
                       (
                           SELECT TOP 1 Type front
                           FROM tbl_portfolioFundkeyfigure kf
                           WHERE kf.PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID 
                              --AND kf.Date=@date
                       )
                       FROM tbl_PortfolioFundKeyfigureConfig
                       WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID;
                --AND date = @date;
        END;
            ELSE
            --Add a row before
            IF @isAdd = 1
               AND @isNext = 0
                BEGIN
                    SET @year =
                    (
                        SELECT DATEADD(year, -1, MIN(year))
                        FROM tbl_PortfolioFundKeyfigure a
                        WHERE a.PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                              --AND date = @date
                              AND YEAR(year) <> '1900'-- don't select closing year (year = 1900)
                    );
                    INSERT INTO tbl_PortfolioFundKeyfigure
                    (PortfolioFundUnderlyingInvestmentsID, 
                     VehicleID, 
                     PortfolioFundKeyfigureConfigID, 
                     Year, 
                     SubTab,
                     --date,
                     Type
                    )
                           SELECT @PortfolioFundUnderlyingInvestmentsID, 
                                  @TargetID, 
                                  PortfolioFundKeyfigureConfigID, 
                                  @year, 
                                  @subTabID,
                                  --@date,
                           (
                               SELECT TOP 1 Type front
                               FROM tbl_PortfolioFundKeyfigure kf
                               WHERE kf.PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                           )
                           FROM tbl_PortfolioFundKeyfigureConfig
                           WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID;
                    --AND date = @date;
            END;
                ELSE

                --delete a row after
                IF @isAdd = 0
                   AND @isNext = 1
                    BEGIN
                        DELETE FROM tbl_PortfolioFundKeyfigure
                        WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                              -- AND date = @date
                              AND YEAR(year) =
                        (
                            SELECT MAX(YEAR(year))
                            FROM tbl_PortfolioFundKeyfigure a
                            WHERE a.PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                                  AND VehicleID = @TargetID
                                  --AND date = @date
                                  AND YEAR(year) <> '1900'-- don't select closing year (year = 1900)
                        );
                END;
                    ELSE

                    --delete a row before
                    IF @isAdd = 0
                       AND @isNext = 0
                        BEGIN
                            DELETE FROM tbl_PortfolioFundKeyfigure
                            WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                                  --AND date = @date
                                  AND YEAR(year) =
                            (
                                SELECT MIN(YEAR(year))
                                FROM tbl_PortfolioFundKeyfigure a
                                WHERE a.PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                                      AND VehicleID = @TargetID
                                      --AND date = @date
                                      AND YEAR(year) <> '1900'-- don't delete closing year (year = 1900)
                            );
                    END;
        SELECT 1;
    END;
