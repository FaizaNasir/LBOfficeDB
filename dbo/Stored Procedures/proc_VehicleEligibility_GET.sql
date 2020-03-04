CREATE PROCEDURE [dbo].[proc_VehicleEligibility_GET] @VehicleID INT = NULL
AS
    BEGIN
        SELECT [VehicleEligibilityID], 
               [VehicleID], 
               [VehicleEligibilityTypeID], 
               [LegalTypeVehicleID], 
               [ConstitutionDate], 
               [LiquidationDate], 
               [LimitDate], 
               [SubscriptionPeriodDate], 
               [EligibilityRatio50Date], 
               [EligibilityRatio0Date], 
               [PercentageEligibile], 
               [MinEmp], 
               [MaxEmp], 
               [HeadquartarID], 
               [MinCapital], 
               [MinRate5Years], 
               [MinRate8Years], 
               [MaxReglementedMarket], 
               [MaxNonReglementedMarket], 
               [MinRatioCapitalIncrease], 
               [MaxRatioCapitalIncrease], 
               [MinRatioConvertibaleBonds], 
               [MaxRatioConvertibaleBonds], 
               [MinTransferSecurity], 
               [MaxTransferSecurity], 
               [MinCurrentAccount], 
               [MaxCurrentAccount], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM tbl_VehicleEligibility
        WHERE VehicleID = @VehicleID;
    END;
