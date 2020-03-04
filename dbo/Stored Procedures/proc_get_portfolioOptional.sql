
CREATE PROC [dbo].[proc_get_portfolioOptional](@portfolioID INT)
AS
    BEGIN
        SELECT PortfolioOptionalID, 
               PortfolioID, 
               DealTypeID, 
        (
            SELECT TOP 1 ProjectTypeTitle
            FROM tbl_dealtype
            WHERE projecttypeid = dealtypeid
        ) DealTypeName, 
               InvestmentBackgroundID, 
        (
            SELECT DealInvestmentBackgroundName
            FROM tbl_DealInvestmentBackground a
            WHERE a.DealInvestmentBackgroundID = po.InvestmentBackgroundID
        ) InvestmentBackgroundName, 
               InvestmentBackgroundNotes, 
               DealThesis, 
               ExitExpectations, 
               IsCommunicated, 
               EnviornmentalRisks, 
               SoicalRisks, 
               GovernanceRisks, 
               MeasureTaken, 
               InvestmentRiskAssessment, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy ModifiedBy, 
               InstrumentType, 
               Region, 
               RegionFr, 
               InvestmentRiskAssessmentFr, 
               DealThesisFr, 
               InstrumentTypeFr, 
               InvestmentBackgroundNotesFr, 
               ExitExpectationsFr, 
               EnviornmentalRisksFr, 
               GovernanceRisksFr, 
               Image2, 
               Image3, 
               FileName, 
               FileNumber, 
               ClosingDate, 
               Holding, 
               Susidiary, 
               ManagementIncentiveScheme, 
               TypeDistributionID, 
               ValueGrowthID, 
               TypeControlID, 
               TypeTechnologyID, 
               AnalysisOnID, 
               Communicated, 
               ControllingStake, 
               (CASE
                    WHEN TypeDistributionID = 1
                    THEN 'B to B'
                    WHEN TypeDistributionID = 2
                    THEN 'B to C'
                END) TypeDistributionName, 
               (CASE
                    WHEN ValueGrowthID = 1
                    THEN 'Growth'
                    WHEN ValueGrowthID = 2
                    THEN 'Value'
                END) ValueGrowthName, 
               (CASE
                    WHEN TypeControlID = 1
                    THEN 'Minority'
                    WHEN TypeControlID = 2
                    THEN 'Joint'
                    WHEN TypeControlID = 3
                    THEN 'Majority'
                END) TypeControlName, 
               (CASE
                    WHEN TypeTechnologyID = 1
                    THEN 'Hightech'
                    WHEN TypeTechnologyID = 2
                    THEN 'Lowtech'
                END) TypeTechnologyName, 
               (CASE
                    WHEN AnalysisOnID = 1
                    THEN 'Holding Company'
                    WHEN AnalysisOnID = 2
                    THEN 'Operating Company'
                END) AnalysisOnName, 
               StatusID, 
               Holding1, 
               dbo.F_GetObjectModuleName(Holding1, 5) Holding1Name, 
               Holding2, 
               dbo.F_GetObjectModuleName(Holding2, 5) Holding2Name, 
               Holding3, 
               dbo.F_GetObjectModuleName(Holding3, 5) Holding3Name
        FROM tbl_portfolioOptional po
        WHERE PortfolioID = @portfolioID;
    END;
