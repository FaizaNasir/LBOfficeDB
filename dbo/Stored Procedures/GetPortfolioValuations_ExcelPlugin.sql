CREATE PROC [dbo].[GetPortfolioValuations_ExcelPlugin]
AS
    BEGIN
        SELECT DISTINCT 
               pval.ValuationID, 
               cc.CompanyName, 
               v.Name VehicleName, 
               pval.Date, 
               pval.InvestmentValue ValuationFX, 
               pval.Discount, 
               pval.Notes, 
               ValuationMethodName, 
               ValuationTypeName, 
               pval.FinalValuation, 
               (pval.InvestmentValue / dbo.[F_GetMultiCurrency](pval.Date, c.CurrencyCode)) ValuationEUR
        FROM tbl_PortfolioValuation pval
             JOIN tbl_Vehicle v ON v.VehicleID = pval.VehicleID
             JOIN tbl_portfolio p ON p.PortfolioID = pval.PortfolioID
             LEFT JOIN tbl_PortfolioLegal pl ON pl.portfolioid = pval.portfolioid
             LEFT JOIN tbl_Currency c ON c.CurrencyID = pl.CurrencyID
             JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
             LEFT JOIN tbl_PortfolioValuationMethod pvm ON pvm.ValuationMethodID = pval.MethodID
             LEFT JOIN tbl_PortfolioValuationType pvt ON pvt.ValuationTypeID = pval.TypeID
        ORDER BY v.name, 
                 cc.CompanyName;
    END;
