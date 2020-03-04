CREATE PROCEDURE [dbo].[Proc_business_report_BI_get](@VehicleID AS VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT DISTINCT 
               PV.portfolioid, 
               Dt.description AS [Portfolio company market description], 
               comments AS [Portfolio company Last business update], 
               [date] AS [Portfolio company last business update date]
        FROM tbl_portfoliovehicle pv
             JOIN tbl_portfolio p ON pv.portfolioid = p.portfolioid
             LEFT JOIN tbl_companybusinessupdates CB ON CB.companyid = PV.portfolioid
             LEFT JOIN tbl_deals Deal ON Deal.dealsourcecompanyid = PV.portfolioid
             LEFT JOIN tbl_dealtarget DT ON DT.dealid = Deal.dealid;

        --WHERE V.VehicleID in(SELECT Value FROM dbo.FnSplit(@VehicleID,',')) 

        SET NOCOUNT OFF;
    END;
