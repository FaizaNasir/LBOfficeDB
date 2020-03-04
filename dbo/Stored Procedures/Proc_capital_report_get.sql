CREATE PROCEDURE [dbo].[Proc_capital_report_get]
(@VehicleID VARCHAR(MAX) = NULL, 
 @Date      DATETIME     = NULL
)
AS
    BEGIN
        SET NOCOUNT ON;
        IF @Date IS NULL
            SET @Date = GETDATE();
        CREATE TABLE #tmpportfoliocompany
        (portfolioid      INT, 
         companycontactid INT, 
         companyname      VARCHAR(MAX) NULL
        );
        INSERT INTO #tmpportfoliocompany
        EXEC Proc_portfolio_list_report_get 
             @VehicleID;
        SELECT DISTINCT 
               vehicleid, 
               pv.portfolioid, 
               dbo.[F_nondiluted](SH.objectid, SH.moduleid, @date, pv.portfolioid) AS Number1, 
               dbo.[F_diluted](SH.objectid, SH.moduleid, @date, pv.portfolioid) AS Number2, 
               dbo.[F_voting](SH.objectid, SH.moduleid, @date, pv.portfolioid) AS Number3,
               CASE
                   WHEN SH.moduleid = 4
                   THEN
        (
            SELECT TOP 1 CI.individualfullname
            FROM [tbl_contactindividual] CI
            WHERE CI.individualid = objectid
        )
                   WHEN SH.moduleid = 5
                   THEN
        (
            SELECT TOP 1 CC.companyname
            FROM [tbl_companycontact] CC
            WHERE CC.companycontactid = objectid
        )
                   WHEN SH.moduleid = 3
                   THEN
        (
            SELECT TOP 1 V.NAME
            FROM [tbl_vehicle] V
            WHERE V.vehicleid = objectid
        )
               END AS NAME
        INTO #tmpcapital 
        --FROM   tbl_PortfolioVehicle pv 
        --JOIN tbl_Portfolio p ON pv.PortfolioID = p.PortfolioID 
        FROM #tmpportfoliocompany PV
             JOIN [tbl_companycontact] CC ON CC.companycontactid = pv.companycontactid
             JOIN tbl_portfolio p ON pv.portfolioid = p.portfolioid
             JOIN tbl_portfoliovehicle V ON V.portfolioid = V.portfolioid
             JOIN tbl_companycontact c ON c.companycontactid = p.targetportfolioid
             LEFT JOIN tbl_shareholders SH ON SH.targetportfolioid = P.targetportfolioid;

        --WHERE VehicleID in(@VehicleID) AND Status IN(1, 2, 3); 
        SELECT vehicleid, 
               portfolioid, 
               ISNULL(SUM(number1), 0) AS sum1, 
               ISNULL(SUM(number2), 0) AS sum2, 
               ISNULL(SUM(number3), 0) AS sum3
        INTO #tmpcal
        FROM #tmpcapital
        GROUP BY vehicleid, 
                 portfolioid;
        SELECT tc.vehicleid, 
               tc.portfolioid, 
               NAME AS [Shareholders names with % owned], 
               CAST(CAST((number1 * 1.0 / (CASE
                                               WHEN sum1 = 0
                                               THEN 1
                                               ELSE sum1
                                           END)) * 100 AS DECIMAL(18, 2)) AS VARCHAR) + '%' AS 'non diluted', 
               CAST(CAST((number2 * 1.0 / (CASE
                                               WHEN sum2 = 0
                                               THEN 1
                                               ELSE sum2
                                           END)) * 100 AS DECIMAL(18, 2)) AS VARCHAR) + '%' AS 'diluted', 
               CAST(CAST((number3 * 1.0 / (CASE
                                               WHEN sum3 = 0
                                               THEN 1
                                               ELSE sum3
                                           END)) * 100 AS DECIMAL(18, 2)) AS VARCHAR) + '%' AS 'voting'
        FROM #tmpcapital tc
             JOIN #tmpcal t ON tc.vehicleid = t.vehicleid
                               AND tc.portfolioid = t.portfolioid;
        IF OBJECT_ID('tempdb..#tmpCapital') IS NOT NULL
            DROP TABLE #tmpcapital;
        IF OBJECT_ID('tempdb..#tmpCal') IS NOT NULL
            DROP TABLE #tmpcal;
        SET NOCOUNT OFF;
    END;
