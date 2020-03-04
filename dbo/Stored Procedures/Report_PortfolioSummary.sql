-- Report_PortfolioSummary 4367, 86;

CREATE PROC [dbo].[Report_PortfolioSummary]
(@companyID INT, 
 @vehicleID INT
)
AS
     DECLARE @date DATETIME;
     SET @date = GETDATE();
     DECLARE @tbl TABLE
     (ObjectID      INT, 
      ModuleID      INT, 
      Name          VARCHAR(1000), 
      Number1       INT, 
      NonDiluted    DECIMAL(18, 6), 
      Number2       INT, 
      Diluted       DECIMAL(18, 6), 
      Number3       INT, 
      Voting        DECIMAL(18, 6), 
      IsTeam        BIT, 
      ShareHolderID INT
     );
     INSERT INTO @tbl
     EXEC proc_capitaltable_GET 
          @date, 
          @TargetPortfolioID = 4367, 
          @portfolioID = 1241;
     SELECT *,
            CASE
                WHEN CostPrice <> 0
                THEN CAST(CAST(ReceivedDistributions / CostPrice AS DECIMAL(18, 1)) AS VARCHAR(10)) + ' x'
                ELSE ''
            END M1,
            CASE
                WHEN CostPrice <> 0
                THEN CAST(CAST(LastValuation / CostPrice AS DECIMAL(18, 1)) AS VARCHAR(10)) + ' x'
                ELSE ''
            END M2,
            CASE
                WHEN CostPrice <> 0
                THEN CAST(CAST((ReceivedDistributions / CostPrice) + LastValuation / CostPrice AS DECIMAL(18, 1)) AS VARCHAR(10)) + ' x'
                ELSE ''
            END M, 
            SUBSTRING(CAST((ReceivedDistributions + LastValuation) / 1000000 AS VARCHAR(1000)), 0, CHARINDEX('.', CAST((ReceivedDistributions + LastValuation) / 1000000 AS VARCHAR(1000)), 0) + 2) TotalValue
     FROM
     (
         SELECT cc.CompanyName,
                CASE
                    WHEN cc.CompanyLogo IS NOT NULL
                    THEN 'http://gvepeps.officectbr.ch/LBOPicturelib/' + cc.CompanyLogo
                END CompanyLogo, 
         (
             SELECT BusinessAreaTitle
             FROM tbl_BusinessArea ba
             WHERE ba.businessareaid = cc.CompanyBusinessAreaID
         ) BusinessDesc, 
                po.GovernanceRisks AmountInvestedbyERES, 
         (
             SELECT ProjectTypeTitle
             FROM tbl_DealType dt
             WHERE dt.ProjectTypeID = po.DealTypeID
         ) Typeofinvestment, 
         (
             SELECT TOP 1 pso.date
             FROM tbl_PortfolioShareholdingOperations pso
             WHERE pso.portfolioid = p.portfolioid
                   AND toid = @vehicleID
                   AND ToTypeID = 3
             ORDER BY pso.date
         ) InvestmentDate, 
                po.MeasureTaken MainInvestors, 
                po.SoicalRisks Intermediatevehicle, 
         (
             SELECT TOP 1 c.Countryname
             FROM tbl_country c
                  JOIN tbl_companyoffice co ON co.CompanyContactID = cc.CompanyContactID
                                               AND co.CountryID = c.CountryID
                                               AND co.IsMain = 1
         ) CountryName, 
                cc.CompanyWebSite, 
                po.InvestmentRiskAssessment Profile, 
                po.DealThesis Overview, 
                po.InvestmentBackgroundNotes InvestmentThesis, 
                po.ExitExpectations ExitStrategy, 
                po.EnviornmentalRisks ESGCriteria, 
         (
             SELECT TOP 1 Comments
             FROM tbl_CompanyBusinessUpdates cbu
             WHERE cbu.CompanyID = cc.companycontactid
             ORDER BY cbu.Date DESC
         ) RecentOperatingAndFinancialEvents, 
         (
             SELECT CompanyIndustryTitle
             FROM tbl_CompanyIndustries ci
             WHERE ci.CompanyIndustryID = cc.CompanyIndustryID
         ) CompanyIndustry, 
         (
             SELECT BusinessAreaTitle
             FROM tbl_BusinessArea ba
             WHERE ba.BusinessAreaID = cc.CompanyBusinessAreaID
         ) Sector, 
                CAST(CAST(dbo.F_GetEnterpriseValue_V1(p.portfolioid) AS DECIMAL(18, 1)) AS VARCHAR(100)) + ' m' Enterprise_Value, 
                CAST(CAST(dbo.F_GetNetFinancialDebt(p.portfolioid) AS DECIMAL(18, 1)) AS VARCHAR(100)) + ' m' NetFinancialDebt, 
                CAST(CAST(dbo.F_GetEnterpriseValue_V1(p.portfolioid) - dbo.F_GetNetFinancialDebt(p.portfolioid) AS DECIMAL(18, 1))

     --*1/
     --(
     --select top 1 NonDiluted from @tbl  tt where tt.name = v.name
     --) as decimal(18,2)) AS VARCHAR(100))

     AS VARCHAR(100)) + ' m' ShareValue, 
                dbo.F_GetCostPriceDisplay(p.portfolioid, pv.VehicleID) CostPriceDisplay, 
                dbo.F_GetCostPrice(p.portfolioid, pv.VehicleID) CostPrice, 
                dbo.F_GetReceivedDistributions(p.portfolioid, pv.VehicleID) ReceivedDistributions, 
                dbo.F_GetLastValuation(p.portfolioid, pv.VehicleID) LastValuation, 
                p.KeyFigureComments, 
                UPPER(v.Name) AS VehicleName, 
         (
             SELECT TOP 1 c.CurrencyCode + '/EUR' + CAST(CAST(rate AS DECIMAL(18, 2)) AS VARCHAR(10))
             FROM tbl_portfoliolegal pl
                  JOIN tbl_currency c ON pl.CurrencyID = c.CurrencyID
                  JOIN tbl_MultiCurrencyRate mc ON c.CurrencyCode = mc.CurrencyID
             WHERE pl.portfolioid = p.portfolioid
             ORDER BY mc.Date DESC
         ) CurrencyRate
         FROM tbl_companycontact cc
              JOIN tbl_portfolio p ON p.TargetPortfolioID = cc.CompanyContactID
              JOIN tbl_PortfolioVehicle pv ON pv.portfolioid = p.portfolioid
                                              AND pv.vehicleid = @vehicleID
              JOIN tbl_vehicle v ON v.vehicleid = pv.VehicleID
              LEFT JOIN tbl_PortfolioOptional po ON po.portfolioid = p.portfolioid
              LEFT JOIN tbl_DealTarget dt ON dt.ModuleObjectID = cc.CompanyContactID
         WHERE cc.companycontactid = @companyID
     ) t;
