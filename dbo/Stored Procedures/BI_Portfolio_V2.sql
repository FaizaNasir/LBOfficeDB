CREATE PROC [dbo].[BI_Portfolio_V2]
AS
     SET NOCOUNT ON;
    BEGIN
        DECLARE @tblKFC TABLE
        (id   INT IDENTITY(1, 1), 
         NAME VARCHAR(1000)
        );
        DECLARE @count INT;
        DECLARE @current INT;
        DECLARE @year INT;
        DECLARE @yearStr VARCHAR(10);
        SET @current = 1;
        SET @year = 0;
        SET @yearStr = 'N';
        INSERT INTO @tblKFC
               SELECT Replace(NAME, '''', ' ')
               FROM
               (
                   SELECT DISTINCT 
                          NAME,
                          CASE
                              WHEN NAME = 'Start Date'
                              THEN 1
                              WHEN NAME = 'End Date'
                              THEN 2
                              WHEN NAME = 'Category'
                              THEN 3
                              ELSE 4
                          END Seq
                   FROM tbl_keyfigureconfig kf
                        JOIN
                   (
                       SELECT DISTINCT 
                              a.portfolioid, 
                       (
                           SELECT TOP 1 date
                           FROM tbl_portfoliokeyfigure b
                           WHERE b.portfolioid = a.portfolioid
                           ORDER BY date DESC
                       ) Date
                       FROM tbl_keyfigureconfig a
                   ) t ON kf.portfolioid = t.portfolioid
                          AND kf.date = t.date
               ) t
               ORDER BY seq, 
                        NAME;
        SET @count =
        (
            SELECT COUNT(1)
            FROM @tblKFC
        );
        DECLARE @sql1 VARCHAR(MAX);
        DECLARE @sql2 VARCHAR(MAX);
        DECLARE @sql6 VARCHAR(MAX);
        DECLARE @kf1 VARCHAR(MAX);
        DECLARE @kf2 VARCHAR(MAX);
        DECLARE @sql3 VARCHAR(MAX);
        DECLARE @sql4 VARCHAR(MAX);
        DECLARE @sql5 VARCHAR(MAX);
        SET @kf1 = '';
        SET @kf2 = '';
        SET @sql1 = ' SELECT ''----General----'' ''----General----'', 
	 p.CompanyContactID ''ID'', 
		 p.CompanyName ''Company name'', v.Name AS ''Fund name'', p.Sector, 
			 p.Industry, 
			 p.BusinessProfile

 ''Business profile'', p.Notes, 
 p.Country,p.CountryISO,p.CountryISO2, p.Address, p.City, p.State, p.ZipCode ''Zip code'', 
		 p.Phone, p.Fax, p.Website, p.CreationDate ''Creation date'', 
		 p.StartCollaborationDate ''Start collaboration date'', 
		 p.CompanyLogo ''Company logo'', 
			 ''----Team----'' ''----Team----'', 
			 ISNULL(i.IndividualTitle, '''') Title, 
			 ISNULL(i.IndividualFirstName, '''') ''First name'', 
					 ISNULL(i.IndividualLastName, '''') ''Last name'', 


 ISNULL( ( SELECT OfficeCity 
		 FROM tbl_companyoffice ico 
		 WHERE ico.officeid = ci.OfficeID ), '''') ''Office city'', 


 CASE WHEN TeamTypeName = ''Adivsory Board'' THEN ''Advisory Board'' ELSE TeamTypeName END ''Team type'', 
	 ISNULL(CASE WHEN TeamTypeName = ''Adivsory Board'' THEN ci.ContactRole ELSE ci.ContactPositionInCompany END, '''') Position, ISNULL(ci.ContactDepartmentInCompany, '''') Department,
		 ci.ContactDateOfJoiningInCompany ''Joined on'', ci.ContactDateOfLeavingFromCompany ''Left on'', CASE WHEN ci.isMainCompany = 1 THEN ''Yes'' ELSE '''' END ''Is main company'', 


 CASE WHEN ci.IsMainIndividual = 1 AND TeamTypeName = ''Executive Team'' THEN ''Yes'' ELSE '''' 
			 END ''Is main individual'', pdti.IndividualFullName ''Deal team member name'', pdt.RoleID ''Deal team member role'', ''----2 Pager----'' ''----2 Pager----'', p.DealType ''Deal type'', 
					 p.InvestmentVehicle ''Investment vehicle'', p.EVAtClosing ''EV at closing'', p.MainInvestors ''Main investors'', p.Locations, p.Profile, p.Overview, p.InstrumentType ''Instrument type'', p.InvestmentThesis ''Investment thesis'', p.ValuationAndExitStrategy ''Valuation and exit strategy'',
					 p.ESGCriteria ''ESG criteria'', p.KYCDone ''KYC done'', p.Transactionreason ''Transaction reason'', ''----Legal----'' ''----Legal----'', dbo.[F_GetPortfolioLegalCapital](p.Portfolioid)Capital, 
						 p.LegalStructure ''Legal structure'', p.LegalRepresentative ''Legal representative'', p.LegalRepresentativeIndividual ''Legal representative individual'', p.TradeRegister ''Trade register'', p.SectorCode ''Sector code'', p.Currency, 


 p.LastCurrencyRate ''Last currency rate'', p.LastCurrencyDate ''Last currency date'', p.Quoted, p.StockExchange ''Stock exchange'', p.TickerSymbol ''Ticker symbol'', 


 p.ContingentLiabilities ''Contingent liabilities'', p.LegalNotes ''Legal notes'', ''----Compliance----'' ''----Compliance----'', pc.PartnerAgreement ''Partner agreement'', pc.ExitClause ''Exit clause'',
 pc.EdRBoardRepresentation ''EdR board representation'', pc.LiquidityClause ''Liquidity clause'', pc.SetupCosts ''Setup costs'', pc.Other, ''----Business updates----'' ''----Business updates----'', p.MarketDescription ''Market description'', 


 p.LastBusinessUpdateDate ''Last business update date'', p.LastBusinessUpdateNotes ''Last business update notes'', ''----Key figures----'' ''----Key figures----'', p.[Year N],';
        WHILE(@current <= @count)
            BEGIN
                SET @sql1 = @sql1 +
                (
                    SELECT 'p.[' + NAME + ' N],'
                    FROM @tblKFC
                    WHERE id = @current
                );
                SET @current = @current + 1;
            END;
        SET @current = 1;
        SET @sql1 = @sql1 + 'p.[Year N 1],';
        WHILE(@current <= @count)
            BEGIN
                SET @sql1 = @sql1 +
                (
                    SELECT 'p.[' + NAME + ' N 1],'
                    FROM @tblKFC
                    WHERE id = @current
                );
                SET @current = @current + 1;
            END;
        SET @current = 1;
        SET @sql1 = @sql1 + 'p.[Year N 2],';
        WHILE(@current <= @count)
            BEGIN
                SET @sql1 = @sql1 +
                (
                    SELECT 'p.[' + NAME + ' N 2],'
                    FROM @tblKFC
                    WHERE id = @current
                );
                SET @current = @current + 1;
            END;
        SET @current = 1;
        SET @sql1 = @sql1 + 'p.[Year N 3],';
        WHILE(@current <= @count)
            BEGIN
                SET @sql1 = @sql1 +
                (
                    SELECT 'p.[' + NAME + ' N 3],'
                    FROM @tblKFC
                    WHERE id = @current
                );
                SET @current = @current + 1;
            END;
        SET @current = 1;
        SET @sql1 = @sql1 + 'p.[Year N 4],';
        WHILE(@current <= @count)
            BEGIN
                SET @sql1 = @sql1 +
                (
                    SELECT 'p.[' + NAME + ' N 4],'
                    FROM @tblKFC
                    WHERE id = @current
                );
                SET @current = @current + 1;
            END;
        SET @current = 1;
        SET @sql2 = ' 
	 p.KeyFigureNotes ''Key figure notes'', ''----Financial amounts----'' ''----Financial amounts----'', ''----EUR----'' ''----EUR----'', 
	 ( SELECT ISNULL(SUM(Amount), 0) 
		 FROM tbl_PortfolioShareholdingOperations WHERE ToTypeID = 3 AND ToID = pv.vehicleID AND PortfolioID = p.PortfolioID AND ISNULL(isConditional, 0) = 0 ) + 
				 ( SELECT ISNULL(SUM(pgo.amount), 0) FROM tbl_PortfolioGeneralOperation pgo WHERE pgo.FromModuleID = 3 AND pgo.FromID = pv.vehicleID AND pgo.TypeID = 5 
				 AND pgo.PortfolioID = p.portfolioid AND ISNULL(isConditional, 0) = 0 ) + ISNULL( ( SELECT TOP 1 CASE WHEN 
				 ( SELECT FromTypeID FROM tbl_PortfolioShareholdingOperations s WHERE ShareholdingOperationID = pfp.ShareholdingOperationID ) = 3 THEN
				  ISNULL(SUM(pfp.AmountDue * -1), 0) ELSE ISNULL(SUM(pfp.AmountDue), 0) END FROM tbl_PortfolioFollowOnPayment pfp INNER JOIN 
				  tbl_PortfolioShareholdingOperations pso ON pso.ShareholdingOperationID = pfp.ShareholdingOperationID WHERE pso.PortfolioID = p.portfolioid AND ISNULL(isConditional, 0) = 0 
				  GROUP BY pfp.ShareholdingOperationID ), 0) + ( SELECT ISNULL(SUM(Amount), 0) FROM tbl_PortfolioGeneralOperation g WHERE g.PortfolioID = p.PortfolioID AND ISNULL(g.isConditional, 0) = 0 
				  AND g.toID = p.CompanyContactID AND g.toModuleID = 5 AND g.FromModuleID = 3 AND g.fromID = pv.vehicleID AND TypeID = 9 ) AS ''Investment'', ISNULL( ( 


 SELECT SUM(ReturnCapitalEUR) FROM tbl_PortfolioShareholdingOperations WHERE ToTypeID = 3 AND ToID = pv.vehicleID AND PortfolioID = p.PortfolioID


 AND ISNULL(isConditional, 0) = 0 ), 0) AS ''Additional commitment'', ISNULL( ( SELECT SUM(Amount) 
 FROM tbl_PortfolioShareholdingOperations WHERE FromTypeID = 3 AND FromID = pv.vehicleID AND PortfolioID = p.PortfolioID AND ISNULL(isConditional, 0) = 0 ), 0) AS


 ''Divestments'', ISNULL( ( SELECT SUM(ReturnCapitalEUR) FROM tbl_PortfolioShareholdingOperations WHERE FromTypeID = 3 AND FromID = pv.vehicleID 


 AND PortfolioID = p.PortfolioID AND ISNULL(isConditional, 0) = 0 ), 0) AS ''Return of capital'', 
 ISNULL( ( SELECT SUM(Amount) FROM tbl_PortfolioShareholdingOperations WHERE FromTypeID = 3 AND FromID = pv.vehicleID AND PortfolioID = p.PortfolioID 


 AND ISNULL(isConditional, 0) = 0 ), 0) - ISNULL( ( SELECT SUM(ReturnCapitalEUR) FROM tbl_PortfolioShareholdingOperations 


 WHERE FromTypeID = 3 AND FromID = pv.vehicleID AND PortfolioID = p.PortfolioID AND ISNULL(isConditional, 0) = 0 ), 0) Profit, AcquisitionFees ''Acquisition fees'', CarriedInterestPaidToSponsor ''Carried interest paid to sponsor'', Dividends, FXHedgingGain ''FX hedging gain'', FXHedgingLoss ''FX hedging loss'',
  InterestAccrued ''Interest accrued'', InterestReceived ''Interest received'', ManagementFees ''Management fees'', Monitoringfees ''Monitoring fees'', SPVFees ''SPV fees'',';
        SET @sql3 = ' ''----FX currency----'' 
 ''----FX currency----'', ( SELECT ISNULL(SUM(ForeignCurrencyAmount), 0) 
 FROM tbl_PortfolioShareholdingOperations WHERE ToTypeID = 3 AND ToID = pv.vehicleID AND PortfolioID = p.PortfolioID AND ISNULL(isConditional, 0) = 0 ) + ( SELECT ISNULL(SUM(pgo.ForeignCurrencyAmount), 0) 
 FROM tbl_PortfolioGeneralOperation pgo WHERE pgo.FromModuleID = 3 AND pgo.FromID = pv.vehicleID AND pgo.TypeID = 5 AND pgo.PortfolioID = p.portfolioid 
 AND ISNULL(isConditional, 0) = 0 ) + ISNULL( ( SELECT TOP 1 CASE WHEN ( SELECT FromTypeID FROM tbl_PortfolioShareholdingOperations s 


 WHERE ShareholdingOperationID = pfp.ShareholdingOperationID ) = 3 THEN ISNULL(SUM(pfp.AmountDueFx * -1), 0) ELSE ISNULL(SUM(pfp.AmountDueFx), 0) 


 END FROM tbl_PortfolioFollowOnPayment pfp INNER JOIN tbl_PortfolioShareholdingOperations pso ON pso.ShareholdingOperationID = pfp.ShareholdingOperationID 


 WHERE pso.PortfolioID = p.portfolioid AND ISNULL(isConditional, 0) = 0 GROUP BY pfp.ShareholdingOperationID ), 0) 
 + ( SELECT ISNULL(SUM(ForeignCurrencyAmount), 0) FROM tbl_PortfolioGeneralOperation g WHERE g.PortfolioID = p.PortfolioID AND ISNULL(g.isConditional, 0) = 0 AND g.toID = p.CompanyContactID AND g.toModuleID = 5 


 AND g.FromModuleID = 3 AND g.fromID = pv.vehicleID AND TypeID = 9 ) AS ''FX investment'',
  ISNULL( ( SELECT SUM(ReturnCapitalFx) FROM tbl_PortfolioShareholdingOperations WHERE ToTypeID = 3 AND ToID = 
  pv.vehicleID AND PortfolioID = p.PortfolioID AND ISNULL(isConditional, 0) = 0 ), 0) AS ''FX additional commitment'', ISNULL( ( SELECT SUM(ForeignCurrencyAmount) FROM tbl_PortfolioShareholdingOperations 


 WHERE FromTypeID = 3 AND FromID = pv.vehicleID AND PortfolioID =
  p.PortfolioID AND ISNULL(isConditional, 0) = 0 ), 0) AS ''FX divestments'', ISNULL( ( SELECT SUM(ReturnCapitalFx) 
  FROM tbl_PortfolioShareholdingOperations WHERE FromTypeID = 3 AND FromID = pv.vehicleID AND PortfolioID = p.PortfolioID AND ISNULL(isConditional, 0) = 0 ), 0) AS ''FX return of capital'',
   ISNULL( ( SELECT SUM(ForeignCurrencyAmount) FROM tbl_PortfolioShareholdingOperations WHERE FromTypeID = 3 AND FromID = pv.vehicleID AND PortfolioID = p.PortfolioID


 AND ISNULL(isConditional, 0) = 0 ), 0) - ISNULL( ( SELECT SUM(ReturnCapitalFx) FROM tbl_PortfolioShareholdingOperations 


 WHERE FromTypeID = 3 AND FromID = pv.vehicleID AND PortfolioID = p.PortfolioID AND ISNULL(isConditional, 0) = 0 ), 0)


 ''FX profit'', FX_AcquisitionFees ''FX acquisition fees'', FX_CarriedInterestPaidToSponsor ''FX carried interest paid to sponsor'', FX_Dividends ''FX dividends'', FX_FXHedgingGain ''FX hedging gain'',
  FX_FXHedgingLoss ''FX hedging loss'', FX_InterestAccrued ''FX interest accrued'', FX_InterestReceived ''FX interest received'', FX_ManagementFees ''FX management fees'', FX_Monitoringfees ''FX monitoring fees'', FX_SPVFees ''FX SPV fees'', ';
        SET @sql4 = '''----Performance----'' ''----Performance----'', pv.IRRNet * 100 ''Investee IRR EUR'', pv.MultipleNet ''Investee multiple EUR'', pv.IRRNetFx * 100 ''Investee IRR FX'', pv.MultipleNetFx
 ''

Investee multiple FX'', ''----Fund valuation----'' ''----Fund valuation----'', pval.*, plval.*, ''----Enterprise values----'' ''----Enterprise values----'',
 pEV.*, plEV.* FROM ( SELECT p.PortfolioID, cc.CompanyContactID, cc.CompanyName, ISNULL( ( SELECT BusinessAreaTitle FROM tbl_BusinessArea ba WHERE ba.BusinessAreaID = 


cc.CompanyBusinessAreaID ), '''') Sector, ISNULL( ( SELECT CompanyIndustryTitle FROM
 tbl_CompanyIndustries ind WHERE ind.CompanyIndustryID = cc.CompanyIndustryID ), '''') Industry, ISNULL(cc.CompanyBusinessDesc, '''') BusinessProfile, cc.CompanyComments Notes, ISNULL( ( SELECT countryname 


 FROM tbl_country c WHERE c.countryid = co.CountryID ), '''') Country,
  ISNULL(( SELECT ISO FROM tbl_country c WHERE c.countryid = co.CountryID ), '''') CountryISO,
   ISNULL(( SELECT ISO2 FROM tbl_country c WHERE c.countryid = co.CountryID ), '''') CountryISO2, co.OfficeAddress Address, co.OfficeCity City, ISNULL( ( SELECT StateTitle FROM tbl_state s 
 

 WHERE s.StateID = co.StateID ), '''') State, co.OfficeZip ZipCode, isnull(cCode.CountryPhoneCode,'''') + '' '' + co.OfficePhone Phone, isnull(cCode.CountryPhoneCode,'''') + '' '' +
  co.OfficeFax Fax, cc.CompanyWebSite WebSite, cc.CompanyCreationDate CreationDate, cc.CompanyStartCollaborationDate StartCollaborationDate, CASE WHEN LEN(ISNULL(cc.CompanyLogo, '''')) = 0 THEN '''' 
ELSE ''http://gvepeps01.officectbr.ch/LBOPicturelib/''+cc.CompanyLogo END CompanyLogo, ( SELECT ProjectTypeTitle FROM tbl_dealtype dt WHERE dt.ProjectTypeID = po.DealTypeID ) DealType,


 ( SELECT DealInvestmentBackgroundName FROM tbl_DealInvestmentBackground dib WHERE dib.DealInvestmentBackgroundID = po.InvestmentBackgroundID ) TransactionReason, po.InvestmentBackgroundNotes InvestmentThesis, po.DealThesis Overview, po.ExitExpectations ValuationAndExitStrategy, po.EnviornmentalRisks ESGCriteria, po.SoicalRisks InvestmentVehicle, 


 po.GovernanceRisks EVAtClosing, po.MeasureTaken MainInvestors, po.Region Locations, po.InvestmentRiskAssessment Profile,
  case when po.IsCommunicated = 1 then ''Yes'' when po.IsCommunicated = 0 then ''No'' else '''' end KYCDone, po.InstrumentType, 
  pl.Capital SocialCapital, pl.LegalStructureID LegalStructure,legalrep.CompanyName LegalRepresentative, dbo.F_PortfolioLegalIndividualName(pl.PortfolioLegalID) LegalRepresentativeIndividual, pl.TradeRegister, pl.SectorCode,
   ( SELECT TOP 1 CurrencyCode FROM tbl_currency cur WHERE cur.currencyid= pl.CurrencyID ) Currency, ( SELECT TOP 1 Rate FROM tbl_MultiCurrencyRate cr
    JOIN tbl_currency cur ON cur.currencycode = cr.CurrencyID WHERE cur.currencyID = pl.CurrencyID ORDER BY date DESC ) LastCurrencyRate, ( SELECT TOP 1 date FROM tbl_MultiCurrencyRate cr 
    JOIN tbl_currency cur ON cur.currencycode = cr.CurrencyID WHERE cur.currencyID = pl.CurrencyID ORDER BY date DESC ) LastCurrencyDate, case when pl.IsQuoted = 1 then
     ''Yes'' else ''No'' end Quoted, pl.StockExchange, pl.TickerSymbol, pl.ContingentLiabilities, pl.LegalNotes, ( SELECT TOP 1 Description FROM 
	tbl_dealtarget dt WHERE dt.moduleobjectID =cc.companycontactid ) MarketDescription, ( SELECT TOP 1 Date FROM tbl_CompanyBusinessUpdates cbu 
	WHERE cbu.CompanyID = cc.companycontactid ORDER BY date DESC ) LastBusinessUpdateDate, ( SELECT TOP 1 Comments FROM tbl_CompanyBusinessUpdates cbu 
	WHERE cbu.CompanyID = cc.companycontactid ORDER BY date DESC ) LastBusinessUpdateNotes, dbo.F_GetKeyFigureYears(p.PortfolioID, 0) ''Year N'',';
        WHILE(@current <= @count)
            BEGIN
                SET @kf1 = @kf1 + 'dbo.F_GetKeyFigureValue(p.PortfolioID, ''' +
                (
                    SELECT NAME
                    FROM @tblKFC
                    WHERE id = @current
                ) + ''', 0) ''' +
                (
                    SELECT NAME + ' N'
                    FROM @tblKFC
                    WHERE id = @current
                ) + ''',';
                SET @current = @current + 1;
            END;
        SET @current = 1;
        SET @kf1 = @kf1 + 'dbo.F_GetKeyFigureYears(p.PortfolioID, 1) ''Year N 1'',';
        WHILE(@current <= @count)
            BEGIN
                SET @kf1 = @kf1 + 'dbo.F_GetKeyFigureValue(p.PortfolioID, ''' +
                (
                    SELECT NAME
                    FROM @tblKFC
                    WHERE id = @current
                ) + ''', 1) ''' +
                (
                    SELECT NAME + ' N 1'
                    FROM @tblKFC
                    WHERE id = @current
                ) + ''',';
                SET @current = @current + 1;
            END;
        SET @current = 1;
        SET @kf1 = @kf1 + 'dbo.F_GetKeyFigureYears(p.PortfolioID, 2) ''Year N 2'',';
        WHILE(@current <= @count)
            BEGIN
                SET @kf2 = @kf2 + 'dbo.F_GetKeyFigureValue(p.PortfolioID, ''' +
                (
                    SELECT NAME
                    FROM @tblKFC
                    WHERE id = @current
                ) + ''', 2) ''' +
                (
                    SELECT NAME + ' N 2'
                    FROM @tblKFC
                    WHERE id = @current
                ) + ''',';
                SET @current = @current + 1;
            END;
        SET @current = 1;
        SET @kf2 = @kf2 + 'dbo.F_GetKeyFigureYears(p.PortfolioID, 3) ''Year N 3'',';
        WHILE(@current <= @count)
            BEGIN
                SET @kf2 = @kf2 + 'dbo.F_GetKeyFigureValue(p.PortfolioID, ''' +
                (
                    SELECT NAME
                    FROM @tblKFC
                    WHERE id = @current
                ) + ''', 3) ''' +
                (
                    SELECT NAME + ' N 3'
                    FROM @tblKFC
                    WHERE id = @current
                ) + ''',';
                SET @current = @current + 1;
            END;
        SET @current = 1;
        SET @kf2 = @kf2 + 'dbo.F_GetKeyFigureYears(p.PortfolioID, 4) ''Year N 4'',';
        WHILE(@current <= @count)
            BEGIN
                SET @kf2 = @kf2 + 'dbo.F_GetKeyFigureValue(p.PortfolioID, ''' +
                (
                    SELECT NAME
                    FROM @tblKFC
                    WHERE id = @current
                ) + ''', 4) ''' +
                (
                    SELECT NAME + ' N 4'
                    FROM @tblKFC
                    WHERE id = @current
                ) + ''',';
                SET @current = @current + 1;
            END;
        SET @sql5 = 'p.KeyFigureComments KeyFigureNotes,p.TargetPortfolioID FROM tbl_portfolio p JOIN tbl_companycontact cc ON cc.companycontactid = p.TargetPortfolioID LEFT 
 JOIN tbl_CompanyOffice co ON co.CompanyContactID = cc.CompanyContactID AND co.IsMain = 1 Left join tbl_country cCode on cCode.CountryID = co.CountryID LEFT JOIN tbl_PortfolioOptional po ON po.portfolioid = p.portfolioid 


 LEFT JOIN tbl_portfoliolegal pl ON pl.portfolioid = p.portfolioid LEFT JOIN tbl_companycontact legalrep ON legalrep.companycontactid = pl.LegalRepresentativeCompanyID )
  p JOIN tbl_portfoliovehicle pv ON pv.portfolioid = p.portfolioid JOIN tbl_vehicle v ON v.vehicleID = pv.vehicleID LEFT JOIN tbl_PortfolioCompliance pc ON pc.PortfolioID = p.PortfolioID OUTER APPLY 
  ( SELECT SUM(AcquisitionFees) AcquisitionFees, SUM(FXHedgingGain) FXHedgingGain, SUM(Monitoringfees) Monitoringfees, SUM(Dividends) Dividends, SUM(InterestReceived) InterestReceived,
   SUM(InterestAccrued) InterestAccrued, SUM(SPVFees) SPVFees, SUM(ManagementFees) ManagementFees, SUM(CarriedInterestPaidToSponsor) CarriedInterestPaidToSponsor, SUM(FXHedgingLoss) FXHedgingLoss, 

 SUM(FX_AcquisitionFees) FX_AcquisitionFees, SUM(FX_FXHedgingGain) FX_FXHedgingGain, SUM(FX_Monitoringfees) FX_Monitoringfees,
  SUM(FX_Dividends) FX_Dividends, 
  SUM(FX_InterestReceived) FX_InterestReceived, SUM(FX_InterestAccrued) FX_InterestAccrued, SUM(FX_SPVFees) FX_SPVFees, SUM(FX_ManagementFees) FX_ManagementFees,
   SUM(FX_CarriedInterestPaidToSponsor) FX_CarriedInterestPaidToSponsor, SUM(FX_FXHedgingLoss) FX_FXHedgingLoss FROM ( SELECT CASE WHEN typeID = 1 THEN SUM(amount) 


 ELSE 0 END AS AcquisitionFees,
  CASE WHEN typeID = 2 THEN SUM(amount) ELSE 0 END AS FXHedgingGain, CASE WHEN typeID = 3 THEN SUM(amount) ELSE 0 END AS Monitoringfees, CASE 


 WHEN typeID = 4 THEN SUM(amount) ELSE 0 END AS Dividends, CASE WHEN typeID = 5 


 THEN SUM(amount) ELSE 0 END AS InterestReceived, CASE WHEN typeID = 6
  THEN SUM(amount) ELSE 0 END AS InterestAccrued, CASE WHEN typeID = 7 THEN SUM(amount) ELSE 0 END AS SPVFees, CASE 


 WHEN typeID = 8 THEN SUM(amount) ELSE 0 END AS ManagementFees, CASE WHEN typeID = 9 


 THEN SUM(amount) ELSE 0 END AS CarriedInterestPaidToSponsor, CASE WHEN typeID = 12 THEN SUM(amount) 


 ELSE 0 END AS FXHedgingLoss, CASE WHEN typeID = 1 THEN SUM(ForeignCurrencyAmount) ELSE 0 END
  AS FX_AcquisitionFees, CASE WHEN typeID = 2 THEN SUM(ForeignCurrencyAmount) ELSE 0 END AS FX_FXHedgingGain, 
  CASE WHEN typeID = 3 THEN SUM(ForeignCurrencyAmount) ELSE 0 END AS FX_MonitoringFees, CASE WHEN typeID = 4 


 THEN SUM(ForeignCurrencyAmount) ELSE 0 END AS FX_Dividends, CASE WHEN typeID = 5 THEN SUM(ForeignCurrencyAmount) 


 ELSE 0 END AS FX_InterestReceived, CASE WHEN typeID = 6 THEN SUM(ForeignCurrencyAmount) ELSE 0 



 END AS FX_InterestAccrued, CASE WHEN typeID = 7 THEN SUM(ForeignCurrencyAmount)
  ELSE 0 END AS FX_SPVFees, CASE WHEN typeID = 8 THEN SUM(ForeignCurrencyAmount) ELSE 0 END AS FX_ManagementFees, CASE 


 WHEN typeID = 9 THEN SUM(ForeignCurrencyAmount) ELSE 0 END AS FX_CarriedInterestPaidToSponsor, CASE WHEN typeID = 12 


 THEN SUM(ForeignCurrencyAmount) ELSE 0 END AS FX_FXHedgingLoss FROM tbl_portfoliogeneraloperation pgo WHERE pgo.PortfolioID = p.portfolioid AND date <= ''' + CAST(GETDATE() AS VARCHAR(20)) + ''' AND 1 = CASE WHEN(FromModuleID = 3 AND FromID = v.vehicleID) OR (ToModuleID = 3 
 

 AND ToID = v.vehicleID) THEN 1 ELSE 0 END GROUP BY typeID ) t ) pgo';
        SET @sql6 = ' OUTER APPLY ( SELECT TOP 1 FinalValuation ''Last valuation EUR'', InvestmentValue ''Last valuation FX'',Date ''Date last valuation'', 
 ( SELECT ValuationTypeName FROM tbl_portfoliovaluationtype pvt WHERE pvt.ValuationTypeID = pval.TypeID ) ''Last valuation type'',
  ( SELECT ValuationMethodName FROM tbl_portfoliovaluationmethod pvm WHERE pvm.ValuationMethodID = pval.MethodID ) ''Last valuation method'', Notes ''Last valuation notes'' 
  FROM tbl_portfoliovaluation pval WHERE pval.portfolioid = p.portfolioid AND pval.vehicleID = pv.vehicleID ORDER BY date DESC ) pval OUTER APPLY ( SELECT TOP 1 FinalValuation 
  ''Before last valuation EUR'', InvestmentValue ''Before last valuation FX'',Date ''Date before last valuation'', ( SELECT ValuationTypeName FROM tbl_portfoliovaluationtype pvt WHERE pvt.ValuationTypeID = pval.TypeID 


 ) ''Before last valuation type'', ( SELECT ValuationMethodName FROM tbl_portfoliovaluationmethod pvm WHERE pvm.ValuationMethodID = pval.MethodID )
  ''Before last valuation method'', Notes ''Before last valuation notes'' FROM tbl_portfoliovaluation pval WHERE pval.portfolioid = p.portfolioid AND
   pval.vehicleID = pv.vehicleID and pval.date < (select top 1 pval_1.date from tbl_portfoliovaluation pval_1 WHERE pval_1.portfolioid = p.portfolioid AND pval_1.vehicleID = pv.vehicleID ORDER BY pval_1.date DESC) 
   ORDER BY date DESC ) plval OUTER APPLY ( SELECT TOP 1 EnterpriseValue/(select top 1 Rate from tbl_multicurrencyrate r where r.currencyID = pev.CurrencyCode and r.Date <= pev.Date order by r.date desc)
    ''Enterprise last valuation EUR'', NetFinancialDebt/(select top 1 Rate from tbl_multicurrencyrate r where r.currencyID = pev.CurrencyCode and r.Date <= pev.Date order by r.date desc) ''Enterprise last net financial debt EUR'', 
    EquityValue/(select top 1 Rate from tbl_multicurrencyrate r where r.currencyID = pev.CurrencyCode and r.Date < pev.Date order by r.date desc) ''Enterprise last equity value EUR'', EnterpriseValue ''Enterprise last valuation FX'', NetFinancialDebt 
    ''Enterprise last net financial debt FX'', EquityValue ''Enterprise last equity value FX'', Notes ''Enterprise last valuation notes'' ,Date ''Enterprise last date last valuation'' FROM tbl_portfolioenterprise pev WHERE pev.portfolioid = p.portfolioid ORDER BY date DESC )
    pEV OUTER APPLY ( SELECT TOP 1 EnterpriseValue/(select top 1 Rate from tbl_multicurrencyrate r where r.currencyID = pev.CurrencyCode and r.Date <= pev.Date order by r.date desc) 
    ''Enterprise before last valuation EUR'', NetFinancialDebt/(select top 1 Rate from tbl_multicurrencyrate r where r.currencyID = pev.CurrencyCode and r.Date <= pev.Date order by r.date desc) ''Enterprise before last net financial debt EUR'', 
    EquityValue/(select top 1 Rate from tbl_multicurrencyrate r where r.currencyID = pev.CurrencyCode and r.Date <= pev.Date order by r.date desc) ''Enterprise before last equity value EUR'', EnterpriseValue ''Enterprise before last valuation FX'', NetFinancialDebt ''Enterprise before last net


 financial debt FX'', EquityValue ''Enterprise before last equity value FX'', Notes ''Enterprise before last valuation notes'' ,Date ''Enterprise before date last valuation'' FROM tbl_portfolioenterprise pev WHERE pev.portfolioid =


 p.portfolioid and pev.date < (select top 1 pev_1.date from tbl_portfolioenterprise pev_1 WHERE pev_1.portfolioid = p.portfolioid ORDER BY pev_1.date DESC) 
 ORDER BY date DESC ) plEV LEFT JOIN tbl_CompanyIndividuals ci ON p.TargetPortfolioID = ci.CompanyContactID LEFT JOIN tbl_ContactIndividual i ON i.individualid = ci.ContactIndividualID LEFT JOIN tbl_PortfolioDealTeam pdt ON pdt.PortfolioID =
  p.PortfolioID LEFT JOIN tbl_ContactIndividual pdti ON pdti.IndividualID = pdt.ContactIndividualID ORDER BY v.Name, p.CompanyName;';
        PRINT @sql1;
        PRINT @sql2;
        PRINT @sql3;
        PRINT @sql4;
        PRINT @kf1;
        PRINT @kf2;
        PRINT @sql5;
        PRINT @sql6;
        EXEC (@sql1+@sql2+@sql3+@sql4+@kf1+@kf2+@sql5+@sql6);
    END; 
