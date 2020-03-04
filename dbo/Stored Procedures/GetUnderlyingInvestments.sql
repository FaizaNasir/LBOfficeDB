CREATE PROC [dbo].[GetUnderlyingInvestments](@date DATETIME)
AS
     IF @date IS NULL
         SET @date = '01/01/2400';
     SELECT CompanyName, 
     (
         SELECT CurrencyCode
         FROM tbl_Currency cur
         WHERE cur.CurrencyID = v.CurrencyID
     ) CurrencyCode, 
            v.Name PortfolioFund,
            CASE
                WHEN v.TypeID = 6
                THEN 1
                ELSE CAST(
     (
         SELECT SUM(amount)
         FROM tbl_PortfolioFundGeneralOperation pfo
         WHERE pfo.VehicleID = v.VehicleID
               AND pfo.TypeID = 1
               AND pfo.FromModuleID = 3
               AND pfo.FromID = pv.VehicleID
               AND pfo.ToModuleID = 3
               AND pfo.ToID = v.VehicleID
     ) AS NUMERIC(25, 12)) / v.Size * 100
            END Owned, 
            v.VehicleID, 
            pv.Name ParentVehicleName, 
            uc.InvestmentDate, 
            BusinessAreaTitle, 
            CountryName, 
            DealType, 
            HighLevelDealType, 
            Segment, 
            ExitEBITDAMultiple, 
            AcquisitionEBITDAMultiple, 
            AcquisitionRevenue, 
            AcquisitionEBITDA, 
            AcquisitionEBIT, 
            AcquisitionNetDebt, 
            AcquisitionDebtEBITDAMultiple, 
            AcquisitionEnterpriseValue,
            CASE
                WHEN ExitDate IS NULL
                THEN 'Portfolio'
                ELSE 'Sold'
            END STATUS, 
            ISNULL(ExitDate, Date) NAVDate, 
            pv.VehicleID ParentVehicleID, 
            cx.*
     FROM tbl_PortfolioFundUnderlyingInvestments uc
          JOIN tbl_vehicle v ON v.vehicleid = uc.vehicleid
          JOIN tbl_VehiclePortfolioFund vpf ON vpf.PortfolioFundID = v.VehicleID
          JOIN tbl_vehicle pv ON pv.VehicleID = vpf.VehicleID
          LEFT JOIN tbl_currency curr ON uc.currencyID = curr.currencyID
          LEFT JOIN tbl_businessarea ba ON ba.BusinessAreaID = uc.BusinessAreaID
          LEFT JOIN tbl_country c ON c.CountryID = uc.countryID
          OUTER APPLY
     (
         SELECT TOP 1 PortfolioFundUnderlyingInvestmentsTrimesterID, 
                      PortfolioFundUnderlyingInvestmentsID, 
                      Date, 
                      Invested, 
                      Proceeds, 
                      NAV, 
                      Multiple, 
                      IRR, 
                      RemainingCommitment
         FROM tbl_PortfolioFundUnderlyingInvestmentsTrimester cx
         WHERE cx.PortfolioFundUnderlyingInvestmentsID = uc.PortfolioFundUnderlyingInvestmentsID
               AND cx.Date <= @date
         ORDER BY cx.Date DESC
     ) cx
     WHERE uc.InvestmentDate <= @date;
