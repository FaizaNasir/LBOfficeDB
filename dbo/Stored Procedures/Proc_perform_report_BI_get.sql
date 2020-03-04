CREATE PROCEDURE [dbo].[Proc_perform_report_BI_get](@VehicleID VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @tmpVehicle AS TABLE(VehicleID INT);
        IF(ISNULL(@VehicleID, '') = '')
            BEGIN
                INSERT INTO @tmpVehicle
                       SELECT vehicleID
                       FROM tbl_Vehicle;
        END;
        BEGIN
            INSERT INTO @tmpVehicle
                   SELECT value
                   FROM dbo.Fnsplit(@VehicleID, ',');
        END;
        DECLARE @nCnt AS INT= 1, @nTotCnt AS INT= 1, @portfolioID INT, @cashinEUR DECIMAL(18, 2), @cashoutEUR DECIMAL(18, 2), @cashinFX DECIMAL(18, 2), @cashoutFX DECIMAL(18, 2);
        CREATE TABLE #tmpperformance
        (

        --[Type]  VARCHAR(20) NULL, 

        isinclude       VARCHAR(30) NULL, 
        [date]          DATETIME NULL, 
        amount          DECIMAL(18, 2) NULL, 
        category        VARCHAR(300) NULL, 
        operationtypeid INT NULL, 
        totypeid        INT NULL, 
        fromtypeid      INT NULL, 
        securetypeid    INT NULL, 
        invtype         VARCHAR(300) NULL
        );
        DECLARE @tmpValues AS TABLE
        (

        --[Type]  VARCHAR(20) NULL, 

        isinclude       VARCHAR(30) NULL, 
        [date]          DATETIME NULL, 
        amount          DECIMAL(18, 2) NULL, 
        category        VARCHAR(300) NULL, 
        operationtypeid INT NULL, 
        totypeid        INT NULL, 
        fromtypeid      INT NULL, 
        securetypeid    INT NULL, 
        invtype         VARCHAR(300) NULL
        );
        CREATE TABLE #tmpactual
        (vehicleid   INT, 
         portfolioid INT, 
         irreur      VARCHAR(30), 
         muleur      VARCHAR(30), 
         irrfx       VARCHAR(30), 
         mulfx       VARCHAR(30)
        );
        SELECT ROW_NUMBER() OVER(
               ORDER BY vehicleid, 
                        portfolioid) AS RowNum, 
               vehicleid, 
               portfolioid
        INTO #tmpvaluation
        FROM tbl_portfoliovaluation
        WHERE vehicleid IN
        (
            SELECT VehicleID
            FROM @tmpVehicle
        );

        --and PortfolioID=183 

        SELECT @nTotCnt = MAX(rownum)
        FROM #tmpvaluation;
        WHILE @nCnt <= @nTotCnt
            BEGIN
                SELECT @VehicleID = vehicleid, 
                       @portfolioID = portfolioid
                FROM #tmpvaluation
                WHERE rownum = @nCnt;

                --INSERT INTO @tmpValues 
                --EXEC [dbo].[Proc_portfolioperformanceget] 
                --  @portfolioID=@portfolioID, 
                --  @targetID=@VehicleID, 
                --  @targetTypeID=3, 
                --  @teamMemberID=NULL, 
                --  @date=NULL 

                SELECT @cashoutEUR = SUM(amount) * -1
                FROM @tmpValues
                WHERE category NOT IN('Valuation');
                SELECT @cashinEUR = SUM(amount)
                FROM @tmpValues
                WHERE category IN('Valuation');
                DELETE FROM @tmpValues;

                --INSERT INTO @tmpValues 
                --EXEC [dbo].[Proc_portfolioperformanceforeigncurrencyget] 
                --  @portfolioID=@portfolioID, 
                --  @targetID=@VehicleID, 
                --  @targetTypeID=3, 
                --  @teamMemberID=NULL, 
                --  @date=NULL 

                SELECT @cashoutFX = SUM(amount) * -1
                FROM @tmpValues
                WHERE category NOT IN('Valuation');
                SELECT @cashinFX = SUM(amount)
                FROM @tmpValues
                WHERE category IN('Valuation');
                DELETE FROM @tmpValues;
                INSERT INTO #tmpactual
                       SELECT @VehicleID, 
                              @portfolioID, 
                              CAST(CAST(((@cashinEUR - @cashoutEUR) / @cashinEUR) * 100 AS DECIMAL(18, 2)) AS VARCHAR) + ' %', 
                              CAST(CAST((@cashinEUR / @cashoutEUR) AS DECIMAL(18, 2)) AS VARCHAR) + ' X', 
                              CAST(CAST(((@cashinFX - @cashoutFX) / @cashinFX) * 100 AS DECIMAL(18, 2)) AS VARCHAR) + ' %', 
                              CAST(CAST((@cashinFX / @cashoutFX) AS DECIMAL(18, 2)) AS VARCHAR) + ' X';
                SELECT @nCnt = @nCnt + 1;
            END;
        SELECT *
        FROM #tmpactual;
        IF OBJECT_ID('tempdb..#tmpValuation') IS NOT NULL
            DROP TABLE #tmpvaluation;
        IF OBJECT_ID('tempdb..#tmpPerformance') IS NOT NULL
            DROP TABLE #tmpperformance;
        IF OBJECT_ID('tempdb..#tmpActual') IS NOT NULL
            DROP TABLE #tmpactual;
        SET NOCOUNT OFF;
    END;
