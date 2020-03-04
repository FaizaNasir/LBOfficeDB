CREATE PROCEDURE [dbo].[Proc_business_report_get](@VehicleID NVARCHAR(MAX) = NULL)
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
        SELECT DISTINCT 
               PV.portfolioid, 
               Dt.description AS [Portfolio company market description], 
               comments AS [Portfolio company Last business update], 
               [date] AS [Portfolio company last business update date]
        FROM #tmpportfoliocompany PV
             JOIN [tbl_companycontact] CC ON CC.companycontactid = pv.companycontactid
             LEFT JOIN tbl_companybusinessupdates CB ON CB.companyid = PV.portfolioid
             LEFT JOIN tbl_deals Deal ON Deal.dealsourcecompanyid = PV.portfolioid
             LEFT JOIN tbl_dealtarget DT ON DT.dealid = Deal.dealid;

        --WHERE V.VehicleID in(SELECT Value FROM dbo.FnSplit(@VehicleID,',')) 

        SET NOCOUNT OFF;
    END;
