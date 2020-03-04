﻿CREATE PROCEDURE [dbo].[proc_Fund_Search] @FundName VARCHAR(100)
AS
    BEGIN
        SELECT F.[FundID], 
               f.FundName, 
               F.[FundManagementCompanyID], 
               F.[FundPOBox], 
               F.FundTypeID, 
               F.[FundDescription], 
               F.[ClosedOn], 
               F.[CurrencyID], 
               F.[FundZipCode], 
               F.[FundAddress], 
               F.[CityID], 
               F.[CountryID], 
               F.[ReportingFrequencyID], 
               F.[ValuationModeID], 
               F.[FundReportingGuidlines], 
               F.[FundDurationYears], 
               F.[FundDurationMonths], 
               F.[FundAdditionalYears], 
               F.[FundInvestmentPeriodMonths], 
               F.[FundInvestmentPeriodYears], 
               F.[FundLegalComments], 
               F.[FundFiscalComments], 
               F.[FundSwiftCode], 
               F.[FundIBANCode], 
               F.[FundCustodianCompanyID], 
               F.[FundInvestmentTypeID], 
               F.[FundNoOfForcastOperationFrom], 
               F.[FundNoOfForcastOperationTo], 
               F.[FundManagementFees], 
               F.[FundHurdleRate], 
               F.[FundCatchUp], 
               F.[FundCarriedIntrest], 
               F.[FundAccountName], 
               F.[FundAccountTypeID], 
               F.[FundAccountCode], 
               f.FundCreationDate, 
               F.[FundAccountComments], 
               F.[IsMainFund], 
               F.[MainFundID], 
               F.[IsSubFund], 
               F.[SubFundRatio], 
               F.[ParentFundID], 
               F.[FundInvestmentSizeFrom], 
               F.[FundInvestmentSizeTo], 
               CC.[CompanyName]
        FROM tbl_Funds F
             LEFT JOIN tbl_CompanyContact CC ON F.FundManagementCompanyID = CC.CompanyContactID
        WHERE F.FundName LIKE '%' + @FundName + '%';
    END;