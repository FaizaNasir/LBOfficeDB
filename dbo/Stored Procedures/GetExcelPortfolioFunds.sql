CREATE PROC [dbo].[GetExcelPortfolioFunds]
AS
    BEGIN
        SELECT PortfolioFundNavID ID, 
        (
            SELECT name
            FROM tbl_vehicle
            WHERE vehicleid = nav.VehicleUnderManagmentID
        ) 'Fund under management', 
               v.name 'Portfolio fund name', 
               v.Size, 
               cc.CompanyName Manager, 
        (
            SELECT currencycode
            FROM tbl_currency c
            WHERE c.CurrencyID = v.CurrencyID
        ) Currency, 
               dbo.F_GetActivityName(v.vehicleid) 'Fund type', 
               '' Region, 
               v.VintageYear 'Vintage year', 
               v.Notes 'Fund description', 
               Date 'Reporting date', 
               TotalNAV 'Total NAV', 
               PortfolioInvestments 'Portfolio investments', 
               PortfolioReevaluation, 
               IncludingCash 'Including cash', 
               IncludingConstitutionFees 'Including constitution fees', 
               IncludingWorkingCapital 'Including working capital', 
               IncludingFXHedging 'Including FX Hedging', 
               IncludingBankDebt 'Including bank debt'
        FROM tbl_vehicle v
             JOIN tbl_companycontact cc ON cc.CompanyContactID = v.ManagementCompanyID
             LEFT JOIN tbl_PortfolioFundNav nav ON v.VehicleID = nav.VehicleID
        WHERE PortfolioFundNavID > 82;
    END;
