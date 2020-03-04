
-- [proc_Fund_GET] 1    

CREATE PROCEDURE [dbo].[proc_Fund_GET] @FundID       INT = NULL, 
                                       @ParentFundID INT = NULL
AS
    BEGIN
        IF(@ParentFundID IS NULL)
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
                       CC.[CompanyName], 
                       F.StateId, 
                       '' StateName, 
                       F.FundRatioRequired, 
                       c.currencycode
                FROM tbl_Funds F
                     JOIN tbl_currency c ON c.currencyid = f.currencyid
                     LEFT JOIN tbl_CompanyContact CC ON F.FundManagementCompanyID = CC.CompanyContactID
                WHERE F.FundID = ISNULL(@FundID, F.FundID); --AND F.FundID =ISNULL(@ParentFundID,F.FundID)      

        END;
            ELSE
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
                       CC.[CompanyName], 
                       F.StateId, 
                       '' StateName, 
                       F.FundRatioRequired, 
                       c.currencycode
                FROM tbl_Funds F
                     JOIN tbl_currency c ON c.currencyid = f.currencyid
                     INNER JOIN tbl_CompanyContact CC ON F.FundManagementCompanyID = CC.CompanyContactID
                WHERE F.FundID = ISNULL(@FundID, F.FundID);
        END;
    END;
