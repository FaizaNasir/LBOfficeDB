CREATE PROCEDURE [dbo].[Proc_bod_report_get](@VehicleID AS VARCHAR(MAX) = NULL)
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
        SELECT PV.portfolioid, 
               COUNT(CC.companycontactid) AS 'Portfolio company number of our firm’s board of directors'
        FROM #tmpportfoliocompany PV
             JOIN [tbl_companycontact] CC ON CC.companycontactid = pv.companycontactid
             LEFT JOIN tbl_companyindividuals CI ON CI.companycontactid = CC.companycontactid
        WHERE --V.VehicleID in(@VehicleID) and  
        teamtypename = 'Board of Directors'
        AND ismaincompany = 1
        GROUP BY PV.portfolioid;
        SET NOCOUNT OFF;
    END;
