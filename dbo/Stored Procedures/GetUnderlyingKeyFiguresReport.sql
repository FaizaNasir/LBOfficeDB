CREATE PROC [dbo].[GetUnderlyingKeyFiguresReport]
AS
     SELECT CompanyName, 
            CurrencyCode, 
            v.Name PortfolioFund, 
            v.VehicleID, 
            pv.Name ParentVehicleName, 
            pv.VehicleID ParentVehicleID, 
            cx.*
     FROM tbl_PortfolioFundUnderlyingInvestments uc
          JOIN tbl_vehicle v ON v.vehicleid = uc.vehicleid
          JOIN tbl_VehiclePortfolioFund vpf ON vpf.PortfolioFundID = v.VehicleID
          JOIN tbl_vehicle pv ON pv.VehicleID = vpf.VehicleID
          LEFT JOIN tbl_currency curr ON uc.currencyID = curr.currencyID
          OUTER APPLY
     (
         SELECT TOP 1 *
         FROM tbl_PortfolioFundUnderlyingInvestmentsTrimester cx
         WHERE cx.PortfolioFundUnderlyingInvestmentsID = uc.PortfolioFundUnderlyingInvestmentsID
         ORDER BY cx.Date DESC
     ) cx;
