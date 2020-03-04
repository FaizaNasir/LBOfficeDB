CREATE PROC [dbo].[GetFofOperation_ExcelPlugin]
AS
    BEGIN
        SELECT sho.OperationID, 
               sho.Date, 
               v.Name VehicleName, 
               pv.Name ParentVehicleName, 
               ps.TypeName,
               CASE
                   WHEN sho.FromModuleID = 3
                   THEN 'Fund'
                   WHEN sho.FromModuleID = 4
                   THEN 'Contact'
                   WHEN sho.FromModuleID = 5
                   THEN 'Company'
               END FromType, 
               dbo.F_GetObjectModuleName(sho.FromID, sho.FromModuleID) [From],
               CASE
                   WHEN sho.ToModuleID = 3
                   THEN 'Fund'
                   WHEN sho.ToModuleID = 4
                   THEN 'Contact'
                   WHEN sho.ToModuleID = 5
                   THEN 'Company'
               END ToType, 
               dbo.F_GetObjectModuleName(sho.ToID, sho.ToModuleID) [To], 
               sho.Amount, 
               sho.ForeignCurrencyAmount, 
               sho.Notes, 
               sho.Investment_ReturnOfCapital, 
               sho.FeeOther_Profits, 
               sho.Investment_ReturnOfCapital_FX, 
               sho.FeeOther_Profits_FX, 
               sho.IncludingRecallableDistribution, 
               sho.IncludingRecallableDistribution_FX
        FROM tbl_PortfolioFundGeneralOperation sho
             JOIN tbl_vehicle v ON v.vehicleID = sho.vehicleID
             JOIN tbl_PortfolioFundGeneralOperationType ps ON ps.TypeID = sho.TypeID
             JOIN tbl_VehiclePortfolioFund pf ON pf.PortfolioFundID = v.vehicleID
             JOIN tbl_vehicle pv ON pv.vehicleID = pf.vehicleID
        ORDER BY v.Name;
    END;
