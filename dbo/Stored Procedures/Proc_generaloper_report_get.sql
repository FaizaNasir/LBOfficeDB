CREATE PROCEDURE [dbo].[Proc_generaloper_report_get](@VehicleID VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        CREATE TABLE #tmpportfoliocompany
        (portfolioid      INT, 
         companycontactid INT, 
         companyname      VARCHAR(MAX) NULL
        );
        INSERT INTO #tmpportfoliocompany
        EXEC Proc_portfolio_list_report_get 
             @VehicleID;
        SELECT portfolioid, 
               [dividends], 
               [acquisition fees], 
               [carried interest paid to sponsor], 
               [fx hedging gain], 
               [fx hedging loss], 
               [interest accrued], 
               [interest received], 
               [management fees], 
               [monitoring fees], 
               [spv fees]
        FROM
        (
            SELECT PGO.portfolioid, 
                   typename, 
                   PGO.amount
            FROM #tmpportfoliocompany PV
                 JOIN [tbl_companycontact] CC ON CC.companycontactid = pv.companycontactid
                 LEFT JOIN tbl_portfoliogeneraloperation PGO ON PGO.portfolioid = Pv.portfolioid
                 JOIN tbl_portfoliogeneraloperationtype PGOT ON PGO.typeid = PGOT.typeid 
            --Where 
            --PV.VehicleID in(@VehicleID) 
            --GROUP BY PortfolioID,PGO.TypeID 
        ) p PIVOT(SUM(amount) FOR typename IN([Dividends], 
                                              [Acquisition fees], 
                                              [Carried interest paid to sponsor], 
                                              [FX Hedging Gain], 
                                              [FX Hedging Loss], 
                                              [Interest accrued], 
                                              [Interest received], 
                                              [Management fees], 
                                              [Monitoring fees], 
                                              [SPV fees])) AS pvt;
        SET NOCOUNT OFF;
    END;
