CREATE PROCEDURE [dbo].[Proc_generaloper_report_BI_get](@VehicleID VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
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
            FROM tbl_portfoliovehicle pv
                 JOIN tbl_portfolio p ON pv.portfolioid = p.portfolioid
                 JOIN [tbl_companycontact] CC ON CC.companycontactid = p.TargetPortfolioID
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
