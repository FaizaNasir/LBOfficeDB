CREATE PROCEDURE [dbo].[proc_Eligibility_GET] @ObjectModuleID INT = NULL, 
                                              @ModuleID       INT = NULL, 
                                              @vehicleID      INT = NULL
AS
    BEGIN
        IF @ModuleID != 7
            SET @vehicleID = NULL;
        SELECT [EligibilityID], 
               [ObjectModuleID], 
               [ModuleID], 
               [EmpNumber], 
               [HeadquarterID], 
               [IsTargetPayTax], 
               [IsCapital], 
               [IsCompanylessthan5Years], 
               [IsCompanylessthan8Years], 
               [QuotationID], 
               [AmountCapitalIncrease], 
               [AmountConvertableBonds], 
               [AmountTransferSecurity], 
               [AmountCurrentAccount], 
               [VehicleID], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM tbl_Eligibility
        WHERE ObjectModuleID = ISNULL(@ObjectModuleID, ObjectModuleID)
              AND ModuleID = ISNULL(@ModuleID, ModuleID)
              AND ISNULL(vehicleID, 0) = ISNULL(@vehicleID, 0);
    END;
