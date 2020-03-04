CREATE PROCEDURE [dbo].[proc_GetAllGeneralOperation] @fundID INT
AS
    BEGIN
        SELECT fundOperation.OperationID, 
               fundOperation.TypeID, 
               operationType.TypeName, 
               fundOperation.Amount, 
               fundOperation.ForeignCurrencyAmount, 
               fundOperation.FromID, 
               fundOperation.FromModuleID, 
               vehicleFrom.Name AS FromName, 
               fundOperation.ToID, 
               fundOperation.ToModuleID, 
               vehicleTo.Name AS ToName, 
               fundOperation.Date
        FROM tbl_PortfolioFundGeneralOperation fundOperation
             LEFT JOIN tbl_PortfolioFundGeneralOperationType operationType ON fundOperation.TypeID = operationType.TypeID
             LEFT JOIN tbl_Vehicle vehicleFrom ON vehicleFrom.VehicleID = fundOperation.FromID
             LEFT JOIN tbl_Vehicle vehicleTo ON vehicleTo.VehicleID = fundOperation.ToID
        WHERE(fundOperation.FromID = @fundID
              OR fundOperation.ToID = @fundID)
             AND fundOperation.FromModuleID = 3
             AND fundOperation.ToModuleID = 3;
    END;
