
--  [proc_FunRatio_Report_Only] '12-31-2016'

CREATE PROC [dbo].[proc_FunRatio_Report_Only](@DateString DATETIME)
AS
     DECLARE @Date DATETIME;
     DECLARE @temp TABLE
     (ID        INT, 
      VehicleID INT
     );
     DECLARE @result TABLE
     (Name       VARCHAR(100), 
      RatioValue DECIMAL(18, 2), 
      Ratio      VARCHAR(1000)
     );
     DECLARE @totalcount INT;
     DECLARE @count INT;
     DECLARE @VehicleID INT;
     DECLARE @Portfolio INT;
     DECLARE @ratio TABLE
     (VehicleID              INT, 
      RatioPrinciple         DECIMAL(18, 4), 
      RatioCapital           DECIMAL(18, 4), 
      Ratio5Year             DECIMAL(18, 4), 
      Ratio8Year             DECIMAL(18, 4), 
      RatioReglemente        DECIMAL(18, 4), 
      RatioNonRelemente      DECIMAL(18, 4), 
      RatioCapitalIncrease   DECIMAL(18, 4), 
      RatioConvertibaleBonds DECIMAL(18, 4), 
      RatioTransferSecurity  DECIMAL(18, 4), 
      RatioCurrentAccount    DECIMAL(18, 4)
     );
     DECLARE @isOperation INT;
     SET @Date = @DateString;-- (select CONVERT(datetime, @DateString, 103))    

    BEGIN
        SET @count = 1;
        INSERT INTO @temp
               SELECT DISTINCT 
                      ROW_NUMBER() OVER(
                      ORDER BY v.VehicleID), 
                      v.VehicleID
               FROM tbl_Vehicle v
               ORDER BY v.VehicleID ASC;
        SET @totalcount =
        (
            SELECT COUNT(VehicleID)
            FROM @temp
        );

        --select @Date 
        INSERT INTO @result
        EXEC proc_GetVehicleRegionRatio_Report 
             @Date;

        --select * from @result   
        --return     

        WHILE(@count <= @totalcount)
            BEGIN
                SET @VehicleID =
                (
                    SELECT VehicleID
                    FROM @temp
                    WHERE ID = @count
                );
                SET @Portfolio =
                (
                    SELECT TOP 1 p.PortfolioID
                    FROM tbl_Portfolio p
                         INNER JOIN tbl_PortfolioVehicle pv ON p.PortfolioID = pv.PortfolioID
                                                               AND pv.VehicleID = @VehicleID
                );
                SET @isOperation =
                (
                    SELECT COUNT(ShareholdingOperationID)
                    FROM tbl_portfolioShareHoldingOperations
                    WHERE 1 = (CASE
                                   WHEN FromTypeID = 3
                                        AND FromID = @vehicleID
                                   THEN 1
                                   WHEN ToTypeID = 3
                                        AND ToID = @vehicleID
                                   THEN 1
                               END)
                          AND PortfolioID IN
                    (
                        SELECT *
                        FROM dbo.[F_CheckEligibility](@vehicleID)
                    )
                    AND Date < @Date
                );
                IF(@isOperation = 0)
                    BREAK;
                    ELSE
                    BEGIN

                        --select @VehicleID, @Portfolio, @Date       

                        INSERT INTO @ratio
                        EXEC [dbo].[proc_PortfolioEligibility_Report] 
                             @VehicleID, 
                             @Portfolio, 
                             @Date;
                        SET @count = @count + 1;
                END;
            END;

        --Select * from @result      

        SELECT Name, 
               RatioValue / 100 RatioValue, 
               Ratio, 
               OrderValue
        FROM
        (
            SELECT Name, 
                   ISNULL(r.RatioPrinciple, 0) AS 'RatioValue', 
                   'Ratio principal' Ratio, 
                   1 AS OrderValue
            FROM @ratio r
                 INNER JOIN tbl_Vehicle v ON r.VehicleID = v.VehicleID
            UNION ALL
            SELECT Name, 
                   ISNULL(r.RatioCapital, 0) AS 'RatioValue', 
                   'Ratio d’' + 'amorçage' Ratio, 
                   2 AS OrderValue
            FROM @ratio r
                 INNER JOIN tbl_Vehicle v ON r.VehicleID = v.VehicleID
            UNION ALL
            SELECT Name, 
                   ISNULL(r.Ratio5Year, 0) AS 'RatioValue', 
                   'Ratio de sociétés de moins de 5 ans' Ratio, 
                   3 AS OrderValue
            FROM @ratio r
                 INNER JOIN tbl_Vehicle v ON r.VehicleID = v.VehicleID
            UNION ALL
            SELECT Name, 
                   ISNULL(r.Ratio8Year, 0) AS 'RatioValue', 
                   'Ratio de sociétés de moins de 8 ans' Ratio, 
                   4 AS OrderValue
            FROM @ratio r
                 INNER JOIN tbl_Vehicle v ON r.VehicleID = v.VehicleID
            UNION ALL
            SELECT Name, 
                   ISNULL(r.RatioReglemente, 0) AS 'RatioValue', 
                   'Ratio sociétés cotées sur marche réglementé' Ratio, 
                   5 AS OrderValue
            FROM @ratio r
                 INNER JOIN tbl_Vehicle v ON r.VehicleID = v.VehicleID
            UNION ALL
            SELECT Name, 
                   ISNULL(r.RatioNonRelemente, 0) AS 'RatioValue', 
                   'Ratio sociétés cotées sur marche non réglementé' Ratio, 
                   6 AS OrderValue
            FROM @ratio r
                 INNER JOIN tbl_Vehicle v ON r.VehicleID = v.VehicleID
            UNION ALL
            SELECT Name, 
                   ISNULL(r.RatioCapitalIncrease, 0) AS 'RatioValue', 
                   'Ratio AK' Ratio, 
                   7 AS OrderValue
            FROM @ratio r
                 INNER JOIN tbl_Vehicle v ON r.VehicleID = v.VehicleID
            UNION ALL
            SELECT Name, 
                   ISNULL(r.RatioConvertibaleBonds, 0) AS 'RatioValue', 
                   'Ratio OC / OBSA' Ratio, 
                   8 AS OrderValue
            FROM @ratio r
                 INNER JOIN tbl_Vehicle v ON r.VehicleID = v.VehicleID
            UNION ALL
            SELECT Name, 
                   ISNULL(r.RatioTransferSecurity, 0) AS 'RatioValue', 
                   'Ratio Transfert de titres' Ratio, 
                   9 AS OrderValue
            FROM @ratio r
                 INNER JOIN tbl_Vehicle v ON r.VehicleID = v.VehicleID
            UNION ALL
            SELECT Name, 
                   ISNULL(r.RatioCurrentAccount, 0) AS 'RatioValue', 
                   'Ratio Compte courant' Ratio, 
                   10 AS OrderValue
            FROM @ratio r
                 INNER JOIN tbl_Vehicle v ON r.VehicleID = v.VehicleID
            UNION ALL
            SELECT *, 
                   40
            FROM @result
        ) t;
    END;

--proc_FunRatio_Report '2015-10-19'   

