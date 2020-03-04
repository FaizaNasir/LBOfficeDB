CREATE PROCEDURE [dbo].[proc_Vehicle_Strategy_FinancialInstrument_GET] @VehicleID INT          = NULL, 
                                                                       @RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT VehicleStrategyFinancialID, 
               tbl_VehicleStrategyFinancialInstrument.FinancialInstrumentID, 
               tbl_VehicleStrategyFinancialInstrument.CreatedDateTime, 
               tbl_VehicleStrategyFinancialInstrument.ModifiedDateTime, 
               'Type' = CASE IsInclude
                            WHEN '1'
                            THEN 'Include'
                            WHEN '0'
                            THEN 'Exclude'
                        END, 
               Percentage, 
               IsInclude, 
               VehicleID, 
               CreatedBy, 
               ModifiedBy, 
               tbl_VehicleStrategyFinancialInstrument.Active, 
               tbl_FinancialInstrument.FinancialInstrumentTitle
        FROM tbl_VehicleStrategyFinancialInstrument
             LEFT OUTER JOIN tbl_FinancialInstrument ON tbl_VehicleStrategyFinancialInstrument.FinancialInstrumentID = tbl_FinancialInstrument.FinancialInstrumentID
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID);
    END;
