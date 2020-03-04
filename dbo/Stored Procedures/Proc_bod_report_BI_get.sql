CREATE PROCEDURE [dbo].[Proc_bod_report_BI_get](@VehicleID AS VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT PV.portfolioid, 
               COUNT(CC.companycontactid) AS 'Portfolio company number of our firm’s board of directors'
        FROM tbl_portfoliovehicle pv
             JOIN tbl_portfolio p ON pv.portfolioid = p.portfolioid
             JOIN [tbl_companycontact] CC ON CC.companycontactid = p.TargetPortfolioID
             LEFT JOIN tbl_companyindividuals CI ON CI.companycontactid = CC.companycontactid
        WHERE --V.VehicleID in(@VehicleID) and  

        teamtypename = 'Board of Directors'
        AND ismaincompany = 1
        GROUP BY PV.portfolioid;
        SET NOCOUNT OFF;
    END;
