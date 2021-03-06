﻿CREATE PROCEDURE [dbo].[proc_Vehicle_Legal_GET] @VehicleID INT          = NULL,   
                                                @RoleName  VARCHAR(100) = NULL  
AS  
    BEGIN  
        SELECT VL.[VehicleLegalID],   
               VL.[VehicleID],   
               VL.[FirstClosingOn],   
               VL.[FinalClosingOn],   
               VL.[LegalVehicleID],   
               VL.[ReportingFrequencyID],   
               VL.[ReportingLimitPeriod],   
               VL.[ReportingValuationID],   
               VL.[LegalStructureID],   
               VL.[InvestmentPeriodYears],   
               VL.[InvestmentPeriodMonths],   
               VL.[DurationPeriodYears],   
               VL.[DurationPeriodMonths],   
               VL.[AdditionalYears],   
               VL.[ReportingObligations],   
               VL.[LegalNotes],   
               VL.[FiscalNotes],   
               VL.[CreatedDateTime],   
               VL.[CreatedBy],   
               VL.[ModifiedDateTime],   
               VL.[ModifiedBy],   
               VL.[Active],   
               VL.ISIN,   
               dbo.F_GetObjectModuleName(VL.Company1, 5) Comapny1,   
               dbo.F_GetObjectModuleName(VL.Company2, 5) Comapny2,   
               dbo.F_GetObjectModuleName(VL.Company3, 5) Comapny3,   
               dbo.F_GetObjectModuleName(VL.Company4, 5) Comapny4,   
               TotalCommitments,   
               FundDomiciliation,   
               dbo.F_GetObjectModuleName(VL.Custodian, 5) Custodian,   
               Custodian CustodianID,   
               dbo.F_GetObjectModuleName(VL.CentralAdministrator, 5) CentralAdministrator,   
               CentralAdministrator CentralAdministratorID,   
               dbo.F_GetObjectModuleName(VL.LegalAdvisor, 5) LegalAdvisor,   
               LegalAdvisor LegalAdvisorID,   
               dbo.F_GetObjectModuleName(VL.CAC, 5) CAC,   
               CAC CACID,   
               dbo.F_GetObjectModuleName(VL.AIFM, 5) AIFM,   
               AIFM AIFMID,   
               dbo.F_GetVehicleLegalCompany(vl.VehicleID) Companies,   
               EngagementsTotaux,   
               Terme,   
               StrategieInvestissement,   
               CouvertureGeographique,   
               LegalVehicleIDFr,   
               ReportingObligationsFr,   
               CarriedInterest,   
               Hurdle,   
               Valorisator,   
               MainRisks,   
               ReportingStandards,   
               ManagementFees,   
               Distributions,   
               EndOfInvestmentPeriod,   
               CarriedInterestFR,   
               HurdleFR,   
               MainRisksFR,   
               ManagementFeesFR,   
               DistributionsFR,   
               TeamCommitment,   
               EndDateAccountingYear,   
               StartInvestmentPeriod,   
               EndInvestmentPeriod,   
               InvestmentPeriodCriteria,   
               ManagementFeeTerms,   
               CapitalAvailableInvestments,   
               DistributionWaterfall  
        FROM tbl_VehicleLegal VL  
        WHERE VL.VehicleID = ISNULL(@VehicleID, VL.VehicleID);  
    END;