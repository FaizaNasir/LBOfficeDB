CREATE PROCEDURE [dbo].[Proc_investshare_report_get](@VehicleID AS VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT portfolioid, 
               ISNULL([equity], 0) AS 'Amount invested in equity', 
               ISNULL([debt], 0) AS 'Amount invested in debt', 
               ISNULL([other], 0) AS 'Amount invested in current account'
        INTO #tmpinvest
        FROM
        (
            SELECT DISTINCT 
                   'Investment' AS Type, 
                   PSO.portfolioid,
                   CASE
                       WHEN PST.securitygroupid = 1
                       THEN 'Equity'
                       WHEN PST.securitygroupid = 2
                       THEN 'Debt'
                       WHEN PST.securitygroupid = 3
                       THEN 'Other'
                   END AS SecurityType,

                   --SUM(Amount) as Amount 

                   PSO.amount
            FROM tbl_portfoliovehicle pv
                 JOIN tbl_portfolio p ON pv.portfolioid = p.portfolioid
                 JOIN tbl_portfolioshareholdingoperations PSO ON PSO.portfolioid = pv.portfolioid
                 JOIN tbl_portfoliosecurity PS ON PSO.securityid = PS.portfoliosecurityid
                                                  AND PSO.portfolioid = PS.portfolioid
                 JOIN tbl_portfoliosecuritytype PST ON PST.portfoliosecuritytypeid = PS.portfoliosecuritytypeid
            WHERE totypeid = 3
                  AND (fromid <> -1
                       AND fromtypeid <> 0)
                  AND YEAR(date) = YEAR(date)

            --GROUP BY PSO.PortfolioID,PST.SecurityGroupID 

        ) p PIVOT(SUM(amount) FOR securitytype IN([Equity], 
                                                  [Debt], 
                                                  [Other])) AS pvt;
        SELECT *, 
               CAST([Amount invested in equity] + [Amount invested in debt] + [Amount invested in current account] AS DECIMAL(18, 2)) AS [Amount Invested]
        FROM #tmpinvest;
        IF OBJECT_ID('tempdb..#tmpInvest') IS NOT NULL
            DROP TABLE #tmpinvest;
        SET NOCOUNT OFF;
    END;
