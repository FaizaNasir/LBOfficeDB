CREATE PROCEDURE [dbo].[Proc_portfolio_legal_report_BI_get](@VehicleID AS VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
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
        FROM tbl_portfoliovehicle pv
             JOIN tbl_portfolio p ON pv.portfolioid = p.portfolioid
             JOIN [tbl_companycontact] CC ON CC.companycontactid = p.TargetPortfolioID
             LEFT JOIN tbl_portfoliolegal pl ON pl.portfolioid = pv.portfolioid
             LEFT OUTER JOIN tbl_portfoliolegalcontactindividual plci ON pl.portfoliolegalid = plci.portfoliolegalid
             LEFT OUTER JOIN tbl_contactindividual CI ON CI.individualid = plci.contactindividualid
             LEFT OUTER JOIN tbl_portfoliolegalstructure pls ON pls.legalstructureid = pl.legalstructureid
             LEFT OUTER JOIN tbl_companycontact CCl ON cc.companycontactid = pl.legalrepresentativecompanyid;

        --Where 
        --VehicleID in(@targetID) 
        SET NOCOUNT OFF;
    END;
