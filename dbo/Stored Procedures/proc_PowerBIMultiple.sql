CREATE PROCEDURE [dbo].[proc_PowerBIMultiple]
AS
    BEGIN
        DECLARE @temp TABLE
        (ID          INT IDENTITY(1, 1), 
         portfolioid INT
        );
        DECLARE @Count INT;
        DECLARE @pid INT;
        DECLARE @result TABLE
        (valution DECIMAL(18, 2), 
         cashin   DECIMAL(18, 2), 
         cashout  DECIMAL(18, 2)
        );
        SET @count = 1;
        INSERT INTO @temp
               SELECT p.portfolioid
               FROM tbl_portfolio p
                    INNER JOIN tbl_portfoliovehicle pv ON pv.PortfolioID = p.PortfolioID
               WHERE pv.VehicleID = 28;
        WHILE(@count) <=
        (
            SELECT COUNT(portfolioid)
            FROM @temp
        )
            BEGIN
                SET @pid =
                (
                    SELECT portfolioid
                    FROM @temp
                    WHERE id = @count
                );
                INSERT INTO tbl_tmpMultiple
                EXEC [dbo].[proc_IBMultiple] 
                     @pid;
                SET @Count = @Count + 1;
            END;
        SELECT *
        FROM tbl_tmpMultiple;
    END;
