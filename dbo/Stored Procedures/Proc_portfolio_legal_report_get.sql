CREATE PROCEDURE [dbo].[Proc_portfolio_legal_report_get](@VehicleID AS VARCHAR(MAX) = NULL)
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
        SELECT pv.portfolioid, 
               capital, 
               legalstructurename AS [Legal structure], 
               CCl.companyname AS [Legal representative company], 
               individualfullname AS [Legal representative individual], 
               traderegister AS [Trade register], 
               sectorcode AS [Sector code], 
               (CASE
                    WHEN isquoted = 1
                    THEN 'Yes'
                    ELSE 'No'
                END) [Quoted], 
               legalnotes AS [Legal notes]
        FROM #tmpportfoliocompany PV
             JOIN [tbl_companycontact] CC ON CC.companycontactid = pv.companycontactid
             LEFT JOIN tbl_portfoliolegal pl ON pl.portfolioid = pv.portfolioid
             LEFT OUTER JOIN tbl_portfoliolegalcontactindividual plci ON pl.portfoliolegalid = plci.portfoliolegalid
             LEFT OUTER JOIN tbl_contactindividual CI ON CI.individualid = plci.contactindividualid
             LEFT OUTER JOIN tbl_portfoliolegalstructure pls ON pls.legalstructureid = pl.legalstructureid
             LEFT OUTER JOIN tbl_companycontact CCl ON cc.companycontactid = pl.legalrepresentativecompanyid;

        --Where 
        --VehicleID in(@targetID) 
        SET NOCOUNT OFF;
    END;
