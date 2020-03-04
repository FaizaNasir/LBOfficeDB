CREATE PROCEDURE [dbo].[proc_Vehicle_Strategy_PortfolioSize_GET] @VehicleID INT          = NULL, 
                                                                 @RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT VehicleStrategyPortfolioSizeID, 
               ForecastFrom, 
               ForecastTo, 
               InvestmentFrom, 
               InvertmentTo, 
               VehicleID, 
               CreatedBy, 
               ModifiedBy, 
               CreatedDateTime, 
               ModifiedDateTime, 
               Active
        FROM tbl_VehicleStrategyPortfolioSize
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID);
    END;
