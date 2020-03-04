CREATE PROCEDURE [dbo].[proc_Eligibility_SET] @ObjectModuleID          INT            = NULL, 
                                              @ModuleID                INT            = NULL, 
                                              @EmpNumber               INT            = NULL, 
                                              @HeadquarterID           INT            = NULL, 
                                              @IsTargetPayTax          BIT            = NULL, 
                                              @IsCapital               BIT            = NULL, 
                                              @IsCompanylessthan5Years BIT            = NULL, 
                                              @IsCompanylessthan8Years BIT            = NULL, 
                                              @QuotationID             INT            = NULL, 
                                              @VehicleID               INT            = NULL, 
                                              @AmountCapitalIncrease   DECIMAL(18, 2)  = NULL, 
                                              @AmountConvertableBonds  DECIMAL(18, 2)  = NULL, 
                                              @AmountTransferSecurity  DECIMAL(18, 2)  = NULL, 
                                              @AmountCurrentAccount    DECIMAL(18, 2)  = NULL, 
                                              @Active                  BIT            = NULL, 
                                              @CreatedDateTime         DATETIME       = NULL, 
                                              @ModifiedDateTime        DATETIME       = NULL, 
                                              @CreatedBy               VARCHAR(100)   = NULL, 
                                              @ModifiedBy              VARCHAR(100)   = NULL
AS
     DECLARE @EligibilityID INT= NULL;
    BEGIN
        IF(@ModuleID = 6)
            BEGIN
                IF NOT EXISTS
                (
                    SELECT 1
                    FROM [tbl_Eligibility]
                    WHERE [ObjectModuleID] = @ObjectModuleID
                          AND ModuleID = @ModuleID
                )
                    BEGIN
                        INSERT INTO tbl_Eligibility
                        (ObjectModuleID, 
                         ModuleID, 
                         EmpNumber, 
                         HeadquarterID, 
                         IsTargetPayTax, 
                         IsCapital, 
                         IsCompanylessthan5Years, 
                         IsCompanylessthan8Years, 
                         QuotationID, 
                         VehicleID, 
                         AmountCapitalIncrease, 
                         AmountConvertableBonds, 
                         AmountTransferSecurity, 
                         AmountCurrentAccount, 
                         Active, 
                         CreatedDateTime, 
                         ModifiedDateTime, 
                         CreatedBy, 
                         ModifiedBy
                        )
                        VALUES
                        (@ObjectModuleID, 
                         @ModuleID, 
                         @EmpNumber, 
                         @HeadquarterID, 
                         @IsTargetPayTax, 
                         @IsCapital, 
                         @IsCompanylessthan5Years, 
                         @IsCompanylessthan8Years, 
                         @QuotationID, 
                         @VehicleID, 
                         @AmountCapitalIncrease, 
                         @AmountConvertableBonds, 
                         @AmountTransferSecurity, 
                         @AmountCurrentAccount, 
                         @Active, 
                         @CreatedDateTime, 
                         @ModifiedDateTime, 
                         @CreatedBy, 
                         @ModifiedBy
                        );
                        SET @EligibilityID = SCOPE_IDENTITY();
                END;
                    ELSE
                    BEGIN
                        UPDATE tbl_Eligibility
                          SET 
                              ObjectModuleID = @ObjectModuleID, 
                              ModuleID = @ModuleID, 
                              EmpNumber = @EmpNumber, 
                              HeadquarterID = @HeadquarterID, 
                              IsTargetPayTax = @IsTargetPayTax, 
                              IsCapital = @IsCapital, 
                              IsCompanylessthan5Years = @IsCompanylessthan5Years, 
                              IsCompanylessthan8Years = @IsCompanylessthan8Years, 
                              QuotationID = @QuotationID, 
                              VehicleID = @VehicleID, 
                              AmountCapitalIncrease = @AmountCapitalIncrease, 
                              AmountConvertableBonds = @AmountConvertableBonds, 
                              AmountTransferSecurity = @AmountTransferSecurity, 
                              AmountCurrentAccount = @AmountCurrentAccount, 
                              Active = @Active, 
                              ModifiedDateTime = @ModifiedDateTime, 
                              ModifiedBy = @ModifiedBy
                        WHERE [ObjectModuleID] = @ObjectModuleID
                              AND ModuleID = @ModuleID;
                        SET @EligibilityID =
                        (
                            SELECT TOP 1 EligibilityID
                            FROM [tbl_Eligibility]
                            WHERE [ObjectModuleID] = @ObjectModuleID
                                  AND ModuleID = @ModuleID
                        );
                END;
                SELECT 'Success' AS Result, 
                       @EligibilityID AS 'EligibilityID';
        END;
            ELSE
            IF(@ModuleID = 7)
                BEGIN
                    IF NOT EXISTS
                    (
                        SELECT 1
                        FROM [tbl_Eligibility]
                        WHERE [ObjectModuleID] = @ObjectModuleID
                              AND ModuleID = @ModuleID
                              AND VehicleID = @VehicleID
                    )
                        BEGIN
                            INSERT INTO tbl_Eligibility
                            (ObjectModuleID, 
                             ModuleID, 
                             EmpNumber, 
                             HeadquarterID, 
                             IsTargetPayTax, 
                             IsCapital, 
                             IsCompanylessthan5Years, 
                             IsCompanylessthan8Years, 
                             QuotationID, 
                             VehicleID, 
                             AmountCapitalIncrease, 
                             AmountConvertableBonds, 
                             AmountTransferSecurity, 
                             AmountCurrentAccount, 
                             Active, 
                             CreatedDateTime, 
                             ModifiedDateTime, 
                             CreatedBy, 
                             ModifiedBy
                            )
                            VALUES
                            (@ObjectModuleID, 
                             @ModuleID, 
                             @EmpNumber, 
                             @HeadquarterID, 
                             @IsTargetPayTax, 
                             @IsCapital, 
                             @IsCompanylessthan5Years, 
                             @IsCompanylessthan8Years, 
                             @QuotationID, 
                             @VehicleID, 
                             @AmountCapitalIncrease, 
                             @AmountConvertableBonds, 
                             @AmountTransferSecurity, 
                             @AmountCurrentAccount, 
                             @Active, 
                             @CreatedDateTime, 
                             @ModifiedDateTime, 
                             @CreatedBy, 
                             @ModifiedBy
                            );
                            SET @EligibilityID = SCOPE_IDENTITY();
                    END;
                        ELSE
                        BEGIN
                            UPDATE tbl_Eligibility
                              SET 
                                  ObjectModuleID = @ObjectModuleID, 
                                  ModuleID = @ModuleID, 
                                  EmpNumber = @EmpNumber, 
                                  HeadquarterID = @HeadquarterID, 
                                  IsTargetPayTax = @IsTargetPayTax, 
                                  IsCapital = @IsCapital, 
                                  IsCompanylessthan5Years = @IsCompanylessthan5Years, 
                                  IsCompanylessthan8Years = @IsCompanylessthan8Years, 
                                  QuotationID = @QuotationID, 
                                  VehicleID = @VehicleID, 
                                  AmountCapitalIncrease = @AmountCapitalIncrease, 
                                  AmountConvertableBonds = @AmountConvertableBonds, 
                                  AmountTransferSecurity = @AmountTransferSecurity, 
                                  AmountCurrentAccount = @AmountCurrentAccount, 
                                  Active = @Active, 
                                  ModifiedDateTime = @ModifiedDateTime, 
                                  ModifiedBy = @ModifiedBy
                            WHERE [ObjectModuleID] = @ObjectModuleID
                                  AND ModuleID = @ModuleID
                                  AND VehicleID = @VehicleID;
                            SET @EligibilityID =
                            (
                                SELECT TOP 1 EligibilityID
                                FROM [tbl_Eligibility]
                                WHERE [ObjectModuleID] = @ObjectModuleID
                                      AND ModuleID = @ModuleID
                                      AND VehicleID = @VehicleID
                            );
                    END;
                    IF @QuotationID = 4
                       AND @ModuleID = 7
                        BEGIN
                            UPDATE tbl_portfolioVehicle
                              SET 
                                  STATUS = 4
                            WHERE portfolioid = @ObjectModuleID
                                  AND vehicleId = @VehicleID;
                    END;
                        ELSE
                        IF @QuotationID <> 4
                           AND @ModuleID = 7
                            BEGIN
                                IF NOT EXISTS
                                (
                                    SELECT TOP 1 1
                                    FROM tbl_PortfolioShareholdingOperations
                                    WHERE FromTypeID = 3
                                          AND FromID = @VehicleID
                                )
                                    UPDATE tbl_PortfolioVehicle
                                      SET 
                                          STATUS = 1
                                    WHERE PortfolioID = @ObjectModuleID
                                          AND VehicleID = @VehicleID;
                                    ELSE
                                    IF EXISTS
                                    (
                                        SELECT TOP 1 1
                                        FROM tbl_PortfolioShareholdingOperations
                                        WHERE FromTypeID = 3
                                              AND FromID = @VehicleID
                                    )
                                        UPDATE tbl_PortfolioVehicle
                                          SET 
                                              STATUS = 2
                                        WHERE PortfolioID = @ObjectModuleID
                                              AND VehicleID = @VehicleID;
                                        ELSE
                                        IF EXISTS
                                        (
                                            SELECT TOP 1 1
                                            FROM tbl_PortfolioShareholdingOperations
                                            WHERE FromTypeID = 3
                                                  AND FromID = @VehicleID
                                        )
                                           AND (
                                        (
                                            SELECT SUM(number)
                                            FROM tbl_PortfolioShareholdingOperations pso
                                            WHERE pso.FromTypeID IN(3, 4, 5)
                                        ) -
                                        (
                                            SELECT SUM(number)
                                            FROM tbl_PortfolioShareholdingOperations pso
                                            WHERE pso.ToTypeID IN(3, 4, 5)
                                        )) = 0
                                            UPDATE tbl_PortfolioVehicle
                                              SET 
                                                  STATUS = 3
                                            WHERE PortfolioID = @ObjectModuleID
                                                  AND VehicleID = @VehicleID;

                                --exec proc_updatePortfolioStatus @ObjectModuleID,@VehicleID

                        END;
                    SELECT 'Success' AS Result, 
                           @EligibilityID AS 'EligibilityID';
            END;
    END;
