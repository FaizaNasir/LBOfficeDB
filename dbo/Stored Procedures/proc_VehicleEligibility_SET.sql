CREATE PROCEDURE [dbo].[proc_VehicleEligibility_SET] @VehicleID                 INT            = NULL, 
                                                     @VehicleEligibilityTypeID  INT            = NULL, 
                                                     @LegalTypeVehicleID        INT            = NULL, 
                                                     @ConstitutionDate          DATE           = NULL, 
                                                     @LiquidationDate           DATE           = NULL, 
                                                     @LimitDate                 DATE           = NULL, 
                                                     @SubscriptionPeriodDate    DATE           = NULL, 
                                                     @EligibilityRatio50Date    DATE           = NULL, 
                                                     @EligibilityRatio0Date     DATE           = NULL, 
                                                     @PercentageEligibile       DECIMAL(18, 2)  = NULL, 
                                                     @MinEmp                    INT            = NULL, 
                                                     @MaxEmp                    INT            = NULL, 
                                                     @HeadquartarID             INT            = NULL, 
                                                     @MinCapital                DECIMAL(18, 2)  = NULL, 
                                                     @MinRate5Years             DECIMAL(18, 2)  = NULL, 
                                                     @MinRate8Years             DECIMAL(18, 2)  = NULL, 
                                                     @MaxReglementedMarket      DECIMAL(18, 2)  = NULL, 
                                                     @MaxNonReglementedMarket   DECIMAL(18, 2)  = NULL, 
                                                     @MinRatioCapitalIncrease   DECIMAL(18, 2)  = NULL, 
                                                     @MaxRatioCapitalIncrease   DECIMAL(18, 2)  = NULL, 
                                                     @MinRatioConvertibaleBonds DECIMAL(18, 2)  = NULL, 
                                                     @MaxRatioConvertibaleBonds DECIMAL(18, 2)  = NULL, 
                                                     @MinTransferSecurity       DECIMAL(18, 2)  = NULL, 
                                                     @MaxTransferSecurity       DECIMAL(18, 2)  = NULL, 
                                                     @MinCurrentAccount         DECIMAL(18, 2)  = NULL, 
                                                     @MaxCurrentAccount         DECIMAL(18, 2)  = NULL, 
                                                     @Active                    BIT            = NULL, 
                                                     @CreatedDateTime           DATETIME       = NULL, 
                                                     @ModifiedDateTime          DATETIME       = NULL, 
                                                     @CreatedBy                 VARCHAR(100)   = NULL, 
                                                     @ModifiedBy                VARCHAR(100)   = NULL
AS
     DECLARE @VehicleEligibilityID INT= NULL;
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM tbl_VehicleEligibility
            WHERE VehicleID = @VehicleID
        )
            BEGIN
                INSERT INTO [tbl_VehicleEligibility]
                (VehicleID, 
                 VehicleEligibilityTypeID, 
                 LegalTypeVehicleID, 
                 ConstitutionDate, 
                 LiquidationDate, 
                 LimitDate, 
                 SubscriptionPeriodDate, 
                 EligibilityRatio50Date, 
                 EligibilityRatio0Date, 
                 PercentageEligibile, 
                 MinEmp, 
                 MaxEmp, 
                 HeadquartarID, 
                 MinCapital, 
                 MinRate5Years, 
                 MinRate8Years, 
                 MaxReglementedMarket, 
                 MaxNonReglementedMarket, 
                 MinRatioCapitalIncrease, 
                 MaxRatioCapitalIncrease, 
                 MinRatioConvertibaleBonds, 
                 MaxRatioConvertibaleBonds, 
                 MinTransferSecurity, 
                 MaxTransferSecurity, 
                 MinCurrentAccount, 
                 MaxCurrentAccount, 
                 Active, 
                 CreatedDateTime, 
                 ModifiedDateTime, 
                 CreatedBy, 
                 ModifiedBy
                )
                VALUES
                (@VehicleID, 
                 @VehicleEligibilityTypeID, 
                 @LegalTypeVehicleID, 
                 @ConstitutionDate, 
                 @LiquidationDate, 
                 @LimitDate, 
                 @SubscriptionPeriodDate, 
                 @EligibilityRatio50Date, 
                 @EligibilityRatio0Date, 
                 @PercentageEligibile, 
                 @MinEmp, 
                 @MaxEmp, 
                 @HeadquartarID, 
                 @MinCapital, 
                 @MinRate5Years, 
                 @MinRate8Years, 
                 @MaxReglementedMarket, 
                 @MaxNonReglementedMarket, 
                 @MinRatioCapitalIncrease, 
                 @MaxRatioCapitalIncrease, 
                 @MinRatioConvertibaleBonds, 
                 @MaxRatioConvertibaleBonds, 
                 @MinTransferSecurity, 
                 @MaxTransferSecurity, 
                 @MinCurrentAccount, 
                 @MaxCurrentAccount, 
                 @Active, 
                 @CreatedDateTime, 
                 @ModifiedDateTime, 
                 @CreatedBy, 
                 @ModifiedBy
                );
                SET @VehicleEligibilityID = SCOPE_IDENTITY();

                --set @VehicleEligibilityID = @@IDENTITY            
                --

        END;
            ELSE
            BEGIN
                UPDATE [tbl_VehicleEligibility]
                  SET 
                      VehicleID = @VehicleID, 
                      VehicleEligibilityTypeID = @VehicleEligibilityTypeID, 
                      LegalTypeVehicleID = @LegalTypeVehicleID, 
                      ConstitutionDate = @ConstitutionDate, 
                      LiquidationDate = @LiquidationDate, 
                      LimitDate = @LimitDate, 
                      SubscriptionPeriodDate = @SubscriptionPeriodDate, 
                      EligibilityRatio50Date = @EligibilityRatio50Date, 
                      EligibilityRatio0Date = @EligibilityRatio0Date, 
                      PercentageEligibile = @PercentageEligibile, 
                      MinEmp = @MinEmp, 
                      MaxEmp = @MaxEmp, 
                      HeadquartarID = @HeadquartarID, 
                      MinCapital = @MinCapital, 
                      MinRate5Years = @MinRate5Years, 
                      MinRate8Years = @MinRate8Years, 
                      MaxReglementedMarket = @MaxReglementedMarket, 
                      MaxNonReglementedMarket = @MaxNonReglementedMarket, 
                      MinRatioCapitalIncrease = @MinRatioCapitalIncrease, 
                      MaxRatioCapitalIncrease = @MaxRatioCapitalIncrease, 
                      MinRatioConvertibaleBonds = @MinRatioConvertibaleBonds, 
                      MaxRatioConvertibaleBonds = @MaxRatioConvertibaleBonds, 
                      MinTransferSecurity = @MinTransferSecurity, 
                      MaxTransferSecurity = @MaxTransferSecurity, 
                      MinCurrentAccount = @MinCurrentAccount, 
                      MaxCurrentAccount = @MaxCurrentAccount, 
                      Active = @Active, 
                      ModifiedDateTime = @ModifiedDateTime, 
                      ModifiedBy = @ModifiedBy
                WHERE VehicleID = @VehicleID;
                SET @VehicleEligibilityID =
                (
                    SELECT TOP 1 VehicleEligibilityID
                    FROM [tbl_VehicleEligibility]
                    WHERE VehicleID = @VehicleID
                );
        END;
        SELECT 'SUCESS' AS RESULT, 
               @VehicleEligibilityID 'VehicleEligibilityID';
    END;
