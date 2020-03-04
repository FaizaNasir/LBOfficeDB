CREATE PROC [dbo].[GetPortfolioFundLegal](@vehicleID INT)
AS
    BEGIN
        SELECT PortfolioFundLegalID, 
               VehicleID, 
               Vehicle, 
               ConstitutionDate, 
               EndSubscriptionPeriod, 
               FundDuration, 
               InvestmentStrategy, 
               GeographicalCoverage, 
               EndInvestmentPeriod, 
               ManagementFees, 
               DateAccountingPeriod, 
               FundProfile, 
               InvestmentsPeriod, 
               InvestmentInstrument, 
               LastDevelopments, 
               ExitsPeriod, 
               CallsAndDistributions, 
               NAV, 
               FundProfileFR, 
               InvestmentsPeriodFR, 
               InvestmentInstrumentFR, 
               LastDevelopmentsFR, 
               ExitsPeriodFR, 
               CallsAndDistributionsFR, 
               NAVFR, 
               FIAManager, 
               Associate, 
               Active, 
               CreatedBy, 
               CreatedDateTime, 
               ModifiedBy, 
               ModifiedDateTime
        FROM tbl_PortfolioFundLegal
        WHERE VehicleID = @VehicleID;
    END;
