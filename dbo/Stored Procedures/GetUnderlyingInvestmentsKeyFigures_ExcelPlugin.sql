CREATE PROC [dbo].[GetUnderlyingInvestmentsKeyFigures_ExcelPlugin]
AS
    BEGIN
        SELECT kf.PortfolioFundKeyFIgureID, 
               uli.CompanyName, 
               v.Name VehicleName, 
               uli.VehicleID, 
               Year, 
               Amount, 
        (
            SELECT TOP 1 Name
            FROM tbl_PortfolioFundKeyFigureConfig kfc
            WHERE kfc.PortfolioFundKeyfigureConfigID = kf.PortfolioFundKeyfigureConfigID
        ) Name
        FROM tbl_PortfolioFundUnderlyingInvestments uli
             JOIN tbl_vehicle v ON v.vehicleid = uli.vehicleid
             JOIN tbl_PortfolioFundKeyFigure kf ON uli.PortfolioFundUnderlyingInvestmentsID = kf.PortfolioFundUnderlyingInvestmentsID
        ORDER BY CompanyName, 
                 Year;
    END;
