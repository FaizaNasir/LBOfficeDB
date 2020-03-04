CREATE PROCEDURE [dbo].[Proc_divestshare_report_BI_get](@VehicleID AS VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT portfolioid, 
               ISNULL([equity], 0) AS 'Amount divested in equity', 
               ISNULL([debt], 0) AS 'Amount divested in debt', 
               ISNULL([other], 0) AS 'Amount divested in current account'
        INTO #tmpdivest
        FROM
        (
            SELECT DISTINCT 
                   'Divestment' AS Type, 
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
                 JOIN tbl_portfolioshareholdingoperations PSO ON PSo.portfolioid = pv.portfolioid
                 JOIN tbl_portfoliosecurity PS ON PSO.securityid = PS.portfoliosecurityid
                                                  AND PSO.portfolioid = PS.portfolioid
                 JOIN tbl_portfoliosecuritytype PST ON PST.portfoliosecuritytypeid = PS.portfoliosecuritytypeid
            WHERE YEAR(date) = YEAR(date)
                  AND fromtypeid <> 0
                  AND fromtypeid = 3 --and VehicleID in(@VehicleID) 
            --GROUP BY PSO.PortfolioID,PST.SecurityGroupID 

        ) p PIVOT(SUM(amount) FOR securitytype IN([Equity], 
                                                  [Debt], 
                                                  [Other])) AS pvt;
        SELECT *, 
               CAST([Amount divested in equity] + [Amount divested in debt] + [Amount divested in current account] AS DECIMAL(18, 2)) AS [Amount Divested]
        FROM #tmpdivest;
        IF OBJECT_ID('tempdb..#tmpDivest') IS NOT NULL
            DROP TABLE #tmpdivest;
        SET NOCOUNT OFF;
    END;
