--[proc_excel_GET] 66 
CREATE PROCEDURE [dbo].[proc_excel_GET] @FundID INT
AS
    BEGIN
        SELECT DISTINCT 
               '-------General-------' AS '-------General-------',
               --cc.CompanyContactID as '----General----',    
               cc.CompanyName AS 'Company name', 
               cc.CompanyAddress AS 'Address', 
               cc.CompanyPOBox AS 'Zip code', 
               c.CityName AS 'City', 
               cn.CountryName AS 'Country', 
               cc.CompanyPhone AS 'Phone', 
               cc.CompanyFax AS 'Fax', 
               cc.CompanyWebSite AS 'Website', 
               cc.CompanyComments AS 'Notes', 
               dt.ProjectTypeTitle AS 'Deal type', 
               dib.DealInvestmentBackgroundName AS 'Transaction reason', 
               po.InvestmentBackgroundNotes AS 'Deal overview', 
               po.DealThesis AS 'Investment thesis', 
               po.ExitExpectations AS 'Exit plan',    
               --(case when po.IsCommunicated = 0 then 'No'    
               --when po.IsCommunicated = 1 then 'Yes'    
               --end)as 'Tax division consulted',    
               po.EnviornmentalRisks AS 'Environmental risks', 
               po.SoicalRisks AS 'Social risks', 
               po.GovernanceRisks AS 'Governance risks', 
               po.MeasureTaken AS 'Measures taken', 
               po.InvestmentRiskAssessment AS 'ESG measures', 
               '-------Legal-------' AS '----Legal----', 
               pl.Capital, 
               pls.LegalStructureName AS 'Legal structure', 
               pl.TradeRegister AS 'Trade register number', 
               pl.SectorCode AS 'Sector class', 
               pl.LegalNotes AS 'Legal notes', 
        (
            SELECT TOP 1 CurrencyCode
            FROM tbl_Currency
            WHERE CurrencyID = pl.CurrencyID
        ) AS 'Currency', 
        (
            SELECT dbo.[F_PortfolioLegalIndividualName](pl.PortfolioLegalID)
        ) AS 'Representative individual', 
        (
            SELECT cc.CompanyName
            FROM tbl_PortfolioLegal pll
                 INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = pll.LegalRepresentativeCompanyID
            WHERE pll.PortfolioLegalID = pl.PortfolioLegalID
        ) AS 'Representative company', 
               '-------Business-------' AS '----Business----', 
               ci.CompanyIndustryTitle AS 'Industry', 
               ba.BusinessAreaTitle AS 'Sector', 
        (
            SELECT TOP 1 cbu.Date
            FROM tbl_CompanyBusinessUpdates cbu
                 INNER JOIN tbl_CompanyContact bcc ON bcc.CompanyContactID = cbu.CompanyID
            WHERE CompanyID = cc.CompanyContactID
            ORDER BY cbu.Date DESC
        ) AS 'Last update notes', 
        (
            SELECT TOP 1 cbu.Comments
            FROM tbl_CompanyBusinessUpdates cbu
                 INNER JOIN tbl_CompanyContact bcc ON bcc.CompanyContactID = cbu.CompanyID
            WHERE CompanyID = cc.CompanyContactID
            ORDER BY cbu.Date DESC
        ) AS 'Recent events', 
        (
            SELECT TOP 1 cbu.Rate
            FROM tbl_CompanyBusinessUpdates cbu
                 INNER JOIN tbl_CompanyContact bcc ON bcc.CompanyContactID = cbu.CompanyID
            WHERE CompanyID = cc.CompanyContactID
            ORDER BY cbu.Date DESC
        ) AS 'Last business update rate', 
               '-------Key figures-------' AS '-------Key figures-------', 
               [dbo].[F_YearN](p.TargetPortfolioID) AS 'Year N', 
               [dbo].[F_CapitalTable_LastTurnover](p.TargetPortfolioID) AS 'Revenues N', 
               [dbo].[F_CapitalTable_LastTurnoverN-1](p.TargetPortfolioID) AS 'Revenues N-1', 
               [dbo].[F_CapitalTable_LastTurnoverN-2](p.TargetPortfolioID) AS 'Revenues N-2', 
               [dbo].[F_CapitalTable_LastTurnoverN-3](p.TargetPortfolioID) AS 'Revenues N-3', 
               [dbo].[F_CapitalTable_LastFCF](p.TargetPortfolioID) AS 'Free cash flows N', 
               [dbo].[F_CapitalTable_FCFN-1](p.TargetPortfolioID) AS 'Free cash flows N-1', 
               [dbo].[F_CapitalTable_FCFN-2](p.TargetPortfolioID) AS 'Free cash flows N-2', 
               [dbo].[F_CapitalTable_FCFN-3](p.TargetPortfolioID) AS 'Free cash flows N-3', 
               [dbo].[F_CapitalTable_LastEBITDA](p.TargetPortfolioID) AS 'EBITDA N', 
               [dbo].[F_CapitalTable_EBITDAN-1](p.TargetPortfolioID) AS 'EBITDA N-1', 
               [dbo].[F_CapitalTable_EBITDAN-2](p.TargetPortfolioID) AS 'EBITDA N-2', 
               [dbo].[F_CapitalTable_EBITDAN-3](p.TargetPortfolioID) AS 'EBITDA N-3', 
               [dbo].[F_CapitalTable_LastEBIT](p.TargetPortfolioID) AS 'EBIT N', 
               [dbo].[F_CapitalTable_EBITN-1](p.TargetPortfolioID) AS 'EBIT N-1', 
               [dbo].[F_CapitalTable_EBITN-2](p.TargetPortfolioID) AS 'EBIT N-2', 
               [dbo].[F_CapitalTable_EBIT-3](p.TargetPortfolioID) AS 'EBIT N-3', 
               [dbo].[F_CapitalTable_LastNetProfit](p.TargetPortfolioID) AS 'Net profit N', 
               [dbo].[F_CapitalTable_LastNetProfitN-1](p.TargetPortfolioID) AS 'Net profit N-1', 
               [dbo].[F_CapitalTable_LastNetProfitN-2](p.TargetPortfolioID) AS 'Net profit N-2', 
               [dbo].[F_CapitalTable_LastNetProfitN-3](p.TargetPortfolioID) AS 'Net profit N-3', 
               [dbo].[F_CapitalTable_LastAdjEPS](p.TargetPortfolioID) AS 'Working capital N', 
               [dbo].[F_CapitalTable_AdjEPSN-1](p.TargetPortfolioID) AS 'Working capital N-1', 
               [dbo].[F_CapitalTable_AdjEPSN-2](p.TargetPortfolioID) AS 'Working capital N-2', 
               [dbo].[F_CapitalTable_AdjEPSN-3](p.TargetPortfolioID) AS 'Working capital N-3', 
               [dbo].[F_CapitalTable_LastGearing](p.TargetPortfolioID) AS 'Net Debt N', 
               [dbo].[F_CapitalTable_GearingN-1](p.TargetPortfolioID) AS 'Net Debt N-1', 
               [dbo].[F_CapitalTable_GearingN-2](p.TargetPortfolioID) AS 'Net Debt N-2', 
               [dbo].[F_CapitalTable_GearingN-3](p.TargetPortfolioID) AS 'Net Debt N-3',

--,[dbo].[F_CapitalTable_LastWorkforce](p.TargetPortfolioID) as 'Financial debt (LT debt) N'    
--,[dbo].[F_CapitalTable_LastWorkforceN-1](p.TargetPortfolioID) as 'Financial debt (LT debt) N-1'    
--,[dbo].[F_CapitalTable_LastWorkforceN-2](p.TargetPortfolioID) as 'Financial debt (LT debt) N-2'    
--,[dbo].[F_CapitalTable_LastWorkforceN-3](p.TargetPortfolioID) as 'Financial debt (LT debt) N-3'     
               [dbo].[F_CapitalTable_LastNetDebt](p.TargetPortfolioID) AS 'Net cash(ST Debt) N', 
               [dbo].[F_CapitalTable_LastNetDebtN-1](p.TargetPortfolioID) AS 'Net cash (ST Debt) N-1', 
               [dbo].[F_CapitalTable_LastNetDebtN-2](p.TargetPortfolioID) AS 'Net cash (ST Debt)N-2', 
               [dbo].[F_CapitalTable_LastNetDebtN-3](p.TargetPortfolioID) AS 'Net cash (ST Debt)N-3',

--,[dbo].[F_CapitalTable_LastNetdebt/EBITDA](p.TargetPortfolioID) as 'Net debt / EBITDA N'  
--,[dbo].[F_CapitalTable_Netdebt/EBITDAN-1](p.TargetPortfolioID) as 'Net debt / EBITDA N-1'  
--,[dbo].[F_CapitalTable_Netdebt/EBITDAN-2](p.TargetPortfolioID) as 'Net debt / EBITDA N-2'  
--,[dbo].[F_CapitalTable_Netdebt/EBITDAN-3](p.TargetPortfolioID) as 'Net debt / EBITDA N-3'  
--,[dbo].[F_CapitalTable_LastFinancialDebt](p.TargetPortfolioID) as 'Net debt / Equity N'  
--,[dbo].[F_CapitalTable_LastFinancialDebtN-1](p.TargetPortfolioID) as 'Net debt / Equity N-1'    
--,[dbo].[F_CapitalTable_LastFinancialDebtN-2](p.TargetPortfolioID) as 'Net debt / Equity N-2'    
--,[dbo].[F_CapitalTable_LastFinancialDebtN-3](p.TargetPortfolioID) as 'Net debt / Equity N-3'     
               '-------Financials-------' AS '----Financials----', 
        (
            SELECT dbo.[F_CapitalTable_NonDiluted]('31 Dec,2016', p.PortfolioID, p.TargetPortfolioID, @FundID, 3)
        ) AS 'Ownership ND', 
        (
            SELECT dbo.[F_CapitalTable_Diluted]('31 Dec,2016', p.PortfolioID, p.TargetPortfolioID, @FundID, 3)
        ) AS 'Ownership FD', 
        (
            SELECT TOP 1 dbo.[F_CapitalTable_VotingRatio]('31 Dec,2016', p.PortfolioID, p.TargetPortfolioID, @FundID, 3)
        ) AS 'Ownership voting',    
--,db.Description as 'Business description'     
        (
            SELECT TOP 1 db.Description
            FROM tbl_DealTarget db
            WHERE p.TargetPortfolioID = db.ModuleObjectID
        ) AS 'Business description', 
        (
            SELECT SUM(Amount)
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @FundID
                  AND PortfolioID = p.PortfolioID
                  AND isConditional = 0
        ) AS 'Investment', 
        (
            SELECT SUM(psho.Amount)
            FROM tbl_PortfolioShareholdingOperations psho
                 INNER JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = psho.SecurityID
                 INNER JOIN tbl_PortfolioSecurityType st ON st.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
                                                            AND SecurityGroupID = 1
            WHERE psho.ToTypeID = 3
                  AND psho.ToID = @FundID
                  AND psho.PortfolioID = p.PortfolioID
        ) AS 'Equity investment', 
        (
            SELECT SUM(psho.Amount)
            FROM tbl_PortfolioShareholdingOperations psho
                 INNER JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = psho.SecurityID
                 INNER JOIN tbl_PortfolioSecurityType st ON st.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
                                                            AND SecurityGroupID = 2
            WHERE psho.ToTypeID = 3
                  AND psho.ToID = @FundID
                  AND psho.PortfolioID = p.PortfolioID
        ) AS 'Loan investment', 
        (
            SELECT SUM(psho.Amount)
            FROM tbl_PortfolioShareholdingOperations psho
                 INNER JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = psho.SecurityID
                 INNER JOIN tbl_PortfolioSecurityType st ON st.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
                                                            AND SecurityGroupID = 3
            WHERE psho.ToTypeID = 3
                  AND psho.ToID = @FundID
                  AND psho.PortfolioID = p.PortfolioID
        ) AS 'Current account investment',

               --,(pv.Amount - dbo.[F_Sho_GetCostOfSoldInvs_Excel](null,null,1,null)) as 'Investment at cost'    
               --,(select top 1 InvestmentValue from                       
               --   tbl_PortfolioValuation pso                      
               --   where pso.PortfolioID = p.PortfolioID                       
               --   and pso.VehicleID = pv.VehicleID order by Date desc) 'Last valuation'    
        (
            SELECT SUM(Amount)
            FROM tbl_PortfolioShareholdingOperations
            WHERE FromTypeID = 3
                  AND FromID = @FundID
                  AND PortfolioID = p.PortfolioID
                  AND isConditional = 0
        ) AS 'Divestment', 
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
                 INNER JOIN tbl_portfoliosecurity ps ON sho.securityid = ps.PortfolioSecurityID
            WHERE FromID = @FundID
                  AND FromTypeID = 3
                  AND sho.portfolioid = p.portfolioid
                  AND ISNULL(isConditional, 0) = 0
                  AND ps.PortfolioSecurityTypeID IN(1, 3, 4)
                 AND DATE <= GETDATE()
        ) AS 'Divestment equity', 
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
                 INNER JOIN tbl_portfoliosecurity ps ON sho.securityid = ps.PortfolioSecurityID
            WHERE FromID = @FundID
                  AND FromTypeID = 3
                  AND sho.portfolioid = p.portfolioid
                  AND ISNULL(isConditional, 0) = 0
                  AND ps.PortfolioSecurityTypeID IN(5, 6, 7)
                 AND DATE <= GETDATE()
        ) AS 'Divestment loan', 
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
                 INNER JOIN tbl_portfoliosecurity ps ON sho.securityid = ps.PortfolioSecurityID
            WHERE FromID = @FundID
                  AND FromTypeID = 3
                  AND sho.portfolioid = p.portfolioid
                  AND ISNULL(isConditional, 0) = 0
                  AND ps.PortfolioSecurityTypeID = 9
                  AND DATE <= GETDATE()
        ) AS 'Divestment current account', 
               ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation s
            WHERE toModuleID = 3
                  AND toid = @FundID
                  AND portfolioid = p.portfolioid
                  AND typeid = 1
                  AND DATE <= GETDATE()
                  AND IsConditional = 0
        ), 0) AS 'Dividends', 
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation s
            WHERE FromModuleID = 3
                  AND FromID = @FundID
                  AND portfolioid = p.portfolioid
                  AND typeid = 5
                  AND DATE <= GETDATE()
                  AND IsConditional = 0
        ) AS 'Acquisition fees', 
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation s
            WHERE FromModuleID = 3
                  AND FromID = @FundID
                  AND ToModuleID = 5
                  AND ToID = p.TargetPortfolioID
                  AND portfolioid = p.portfolioid
                  AND typeid = 9
                  AND IsConditional = 0
        ) AS 'FX Hedging Loss', 
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation s
            WHERE FromModuleID = 5
                  AND FromID = p.TargetPortfolioID
                  AND ToModuleID = 3
                  AND ToID = @FundID
                  AND portfolioid = p.portfolioid
                  AND typeid = 9
                  AND IsConditional = 0
        ) AS 'FX Hedging Gain', 
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation s
            WHERE toModuleID = 3
                  AND toid = @FundID
                  AND portfolioid = p.portfolioid
                  AND typeid = 6
                  AND DATE <= GETDATE()
                  AND IsConditional = 0
        ) AS 'Exit fees', 
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation s
            WHERE toModuleID = 3
                  AND toid = @FundID
                  AND portfolioid = p.portfolioid
                  AND typeid = 7
                  AND DATE <= GETDATE()
                  AND IsConditional = 0
        ) AS 'Other fees', 
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation s
            WHERE toModuleID = 3
                  AND toid = @FundID
                  AND portfolioid = p.portfolioid
                  AND typeid = 2
                  AND DATE <= GETDATE()
                  AND IsConditional = 0
        ) AS 'Paid interest', 
               '-------Valuations-------' AS '-------Valuations-------', 
        (
            SELECT TOP 1 CASE
                             WHEN pv.Discount <> 0
                             THEN pv.FinalValuation
                             ELSE InvestmentValue
                         END
            FROM tbl_PortfolioValuation pv
            WHERE pv.vehicleid = @FundID
                  AND portfolioid = p.portfolioid
                  AND DATE <= GETDATE()
            ORDER BY date ASC
        ) AS 'Last valuation', 
        (
            SELECT TOP 1 pv.Date
            FROM tbl_PortfolioValuation pv
            WHERE pv.vehicleid = @FundID
                  AND portfolioid = p.portfolioid
                  AND DATE <= GETDATE()
            ORDER BY date ASC
        ) AS 'Last valuation date', 
        (
            SELECT TOP 1 pvm.ValuationMethodName
            FROM tbl_PortfolioValuation pv
                 INNER JOIN tbl_PortfolioValuationMethod pvm ON pvm.ValuationMethodID = pv.MethodID
            WHERE pv.vehicleid = @FundID
                  AND portfolioid = p.portfolioid
                  AND DATE <= GETDATE()
            ORDER BY date ASC
        ) AS 'Last valuation method', 
        (
            SELECT TOP 1 pv.Notes
            FROM tbl_PortfolioValuation pv
            WHERE pv.vehicleid = @FundID
                  AND portfolioid = p.portfolioid
                  AND DATE <= GETDATE()
            ORDER BY date ASC
        ) AS 'Last valuation notes', 
               dbo.[F_BeforeLast_Valuation](@FundID, p.portfolioid, GETDATE()) AS 'Last valuation - 1', 
               dbo.[F_BeforeLast_Valuation_Date](@FundID, p.portfolioid, GETDATE()) AS 'Last valuation date - 1', 
               dbo.[F_BeforeLast_Valuation_Method](@FundID, p.portfolioid, GETDATE()) AS 'Last valuation method - 1', 
               dbo.[F_BeforeLast_Valuation_Note](@FundID, p.portfolioid, GETDATE()) AS 'Last valuation notes - 1'
        FROM tbl_Portfolio p
             INNER JOIN tbl_PortfolioVehicle pv ON p.PortfolioID = pv.PortfolioID
             INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
             LEFT OUTER JOIN tbl_City c ON cc.CompanyCityID = c.CityID
             LEFT OUTER JOIN tbl_Country cn ON cc.CompanyCountryID = cn.CountryID
             LEFT OUTER JOIN tbl_PortfolioOptional po ON p.PortfolioID = po.PortfolioID
             LEFT OUTER JOIN tbl_DealType dt ON po.DealTypeID = dt.ProjectTypeID
             LEFT OUTER JOIN tbl_DealInvestmentBackground dib ON po.InvestmentBackgroundID = dib.DealInvestmentBackgroundID
             LEFT OUTER JOIN tbl_PortfolioLegal pl ON pl.PortfolioID = p.PortfolioID
             LEFT OUTER JOIN tbl_PortfolioLegalStructure pls ON pls.LegalStructureID = pl.LegalStructureID
             LEFT OUTER JOIN tbl_CompanyIndustries ci ON cc.CompanyIndustryID = ci.CompanyIndustryID
             LEFT OUTER JOIN tbl_BusinessArea ba ON ba.BusinessAreaID = cc.CompanyBusinessAreaID    
             --left outer join tbl_DealTarget db on p.TargetPortfolioID = db.ModuleObjectID    
             LEFT OUTER JOIN tbl_PortfolioPerformanceActual ppa ON ppa.PortfolioID = p.PortfolioID
                                                                   AND ppa.CompanyID = p.TargetPortfolioID
        WHERE pv.VehicleID = @FundID;
    END;
