
CREATE PROC [dbo].[UpdateKeyFigIncludeInReport](@portfolioID INT)
AS
    BEGIN
        DECLARE @currentYear DATETIME;
        DECLARE @prevYear INT;
        DECLARE @nextYear INT;
        DECLARE @count INT;
        DECLARE @current INT;
        DECLARE @keyFigID INT;
        SET @current = 1;
        DECLARE @tbl TABLE
        (ID          INT IDENTITY(1, 1), 
         PortfolioID INT, 
         Date        DATETIME
        );
        INSERT INTO @tbl
               SELECT DISTINCT 
                      a.PortfolioID, 
                      a.date
               FROM tbl_portfoliokeyfigure a
                    JOIN tbl_keyfigureconfig b ON a.KeyFigureConfigID = b.KeyFigureConfigID
               WHERE a.portfolioid = @portfolioID
                     AND b.name LIKE 'Include in report'
                     AND b.date = a.date;
        SET @count =
        (
            SELECT COUNT(1)
            FROM @tbl
        );
        WHILE @current <= @count
            BEGIN
                SET @currentYear =
                (
                    SELECT date
                    FROM @tbl
                    WHERE ID = @current
                );
                SELECT @currentYear;
                SET @keyFigID =
                (
                    SELECT TOP 1 KeyFIgureID
                    FROM tbl_portfoliokeyfigure a
                         JOIN tbl_keyfigureconfig b ON a.KeyFigureConfigID = b.KeyFigureConfigID
                    WHERE a.portfolioid = @portfolioID
                          AND b.name LIKE 'Include in report'
                          AND b.date = a.date
                          AND b.date = @currentYear
                          AND YEAR(a.year) = YEAR(@currentYear)
                );
                SELECT @keyFigID;
                IF @keyFigID IS NOT NULL
                    BEGIN
                        UPDATE tbl_portfoliokeyfigure
                          SET 
                              amount = 'Yes'
                        WHERE KeyFIgureID = @keyFigID;
                END;
                SET @keyFigID =
                (
                    SELECT TOP 1 KeyFIgureID
                    FROM tbl_portfoliokeyfigure a
                         JOIN tbl_keyfigureconfig b ON a.KeyFigureConfigID = b.KeyFigureConfigID
                    WHERE a.portfolioid = @portfolioID
                          AND b.name LIKE 'Include in report'
                          AND b.date = a.date
                          AND b.date = @currentYear
                          AND YEAR(a.year) = YEAR(@currentYear) - 1
                );
                SELECT @keyFigID;
                IF @keyFigID IS NOT NULL
                    BEGIN
                        UPDATE tbl_portfoliokeyfigure
                          SET 
                              amount = 'Yes'
                        WHERE KeyFIgureID = @keyFigID;
                END;
                SET @keyFigID =
                (
                    SELECT TOP 1 KeyFIgureID
                    FROM tbl_portfoliokeyfigure a
                         JOIN tbl_keyfigureconfig b ON a.KeyFigureConfigID = b.KeyFigureConfigID
                    WHERE a.portfolioid = @portfolioID
                          AND b.name LIKE 'Include in report'
                          AND b.date = a.date
                          AND b.date = @currentYear
                          AND YEAR(a.year) = YEAR(@currentYear) + 1
                );
                SELECT @keyFigID;
                IF @keyFigID IS NOT NULL
                    BEGIN
                        UPDATE tbl_portfoliokeyfigure
                          SET 
                              amount = 'Yes'
                        WHERE KeyFIgureID = @keyFigID;
                END;
                SET @current = @current + 1;
            END;
    END;
