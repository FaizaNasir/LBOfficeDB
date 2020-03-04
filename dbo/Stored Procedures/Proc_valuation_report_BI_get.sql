CREATE PROCEDURE [dbo].[Proc_valuation_report_BI_get](@VehicleID AS VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT ROW_NUMBER() OVER(PARTITION BY PV.portfolioid
               ORDER BY PV.portfolioid, 
                        PV.modifieddatetime DESC) RowNum, 
               PV.portfolioid, 
               finalvaluation, 
               investmentvalue, 
               date, 
               valuationtypename, 
               valuationmethodname
        INTO #tmpvaluation
        FROM tbl_portfoliovehicle pva
             JOIN tbl_portfolio p ON pva.portfolioid = p.portfolioid
             JOIN [tbl_companycontact] CC ON CC.companycontactid = p.TargetPortfolioID
             LEFT JOIN tbl_portfoliovaluation PV ON PV.portfolioid = p.portfolioid
             LEFT JOIN tbl_portfoliovaluationtype PVT ON PV.typeid = PVT.valuationtypeid
             LEFT JOIN tbl_portfoliovaluationmethod PVM ON PV.methodid = PVM.valuationmethodid;

        --Where V.VehicleID in(@VehicleID) 
        SELECT A.portfolioid, 
               A.finalvaluation AS [Last valuation EUR], 
               A.investmentvalue AS [Last valuation FX], 
               A.date AS [Last valuation date], 
               A.valuationtypename AS [Last valuation type], 
               A.valuationmethodname AS [Last valuation method], 
               B.finalvaluation AS [Before valuation EUR], 
               B.investmentvalue AS [Before valuation FX], 
               B.date AS [Before valuation date], 
               B.valuationtypename AS [Before valuation type], 
               B.valuationmethodname AS [Before valuation method]
        FROM
        (
            SELECT 'last' AS Type, 
                   rownum, 
                   portfolioid, 
                   finalvaluation, 
                   investmentvalue, 
                   date, 
                   valuationtypename, 
                   valuationmethodname
            FROM #tmpvaluation
            WHERE rownum = 1
        ) A
        LEFT JOIN
        (
            SELECT 'before' AS Type, 
                   rownum, 
                   portfolioid, 
                   finalvaluation, 
                   investmentvalue, 
                   date, 
                   valuationtypename, 
                   valuationmethodname
            FROM #tmpvaluation
            WHERE rownum = 2
        ) B ON A.portfolioid = B.portfolioid
        WHERE A.portfolioid IS NOT NULL;
        IF OBJECT_ID('tempdb..#tmpValuation') IS NOT NULL
            DROP TABLE #tmpvaluation;
        SET NOCOUNT OFF;
    END;
