CREATE PROC [dbo].[GetExcelUnderlyingInvestmentsDetail]
AS
    BEGIN
        SELECT *
        FROM
        (
            SELECT PortfolioFundUnderlyingInvestmentsTrimesterID ID, 
            (
                SELECT name
                FROM tbl_vehicle
                WHERE vehicleid =
                (
                    SELECT TOP 1 VehicleID
                    FROM tbl_VehiclePortfolioFund f
                    WHERE f.PortfolioFundid = i.VehicleID
                )
            ) 'Fund under management', 
            (
                SELECT name
                FROM tbl_vehicle v
                WHERE v.vehicleid = i.VehicleID
            ) 'Portfolio fund name', 
                   i.CompanyName 'Underlying company', 
                   '' 'Deal type', 
            (
                SELECT BusinessAreaTitle
                FROM tbl_businessarea ba
                WHERE ba.BusinessAreaID = i.BusinessAreaID
            ) Sector, 
                   DealType, 
                   HighLevelDealType, 
                   Segment, 
                   BusinessDescription, 
            (
                SELECT countryName
                FROM tbl_Country c
                WHERE c.CountryID = i.CountryID
            ) Country, 
            (
                SELECT currencycode
                FROM tbl_Currency c
                WHERE c.CurrencyID = i.CurrencyID
            ) Currency, 
                   i.InvestmentDate 'Closing date', 
                   i.ExitDate 'Exit date', 
                   i.AcquisitionEBITDAMultiple 'EBITDA Acquisition multiple', 
                   i.ExitEBITDAMultiple 'EBITDA Exit multiple', 
                   i.AcquisitionRevenue 'Acquisition Revenue', 
                   i.AcquisitionEBITDA 'Acquisition EBITDA', 
                   i.AcquisitionEBIT 'Acquisition EBIT', 
                   i.AcquisitionNetDebt 'Acquisition Net Debt', 
                   i.AcquisitionDebtEBITDAMultiple 'Acquisition Debt EBITDA Multiple', 
                   i.AcquisitionEnterpriseValue 'Acquisition Enterprise Value', 
                   j.Date 'Report date', 
                   j.Invested 'Investment', 
                   j.Proceeds, 
                   j.NAV 'Last NAV', 
                   j.Multiple, 
                   j.IRR, 
                   j.RemainingCommitment 'Other commitments', 
                   j.Owned
            FROM tbl_PortfolioFundUnderlyingInvestments i
                 LEFT JOIN tbl_PortfolioFundUnderlyingInvestmentsTrimester j ON i.PortfolioFundUnderlyingInvestmentsID = j.PortfolioFundUnderlyingInvestmentsID
            WHERE vehicleid <> 0
        ) t
        WHERE t.[Fund under management] IS NOT NULL
              AND t.[Portfolio fund name] IS NOT NULL;
    END;
