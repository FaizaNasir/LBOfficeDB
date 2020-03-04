
-- created by	:	Syed Zain ALi

CREATE PROCEDURE [dbo].[proc_SubFunds_GET] @ParentFundID INT, 
                                           @SubFundID    INT
AS
    BEGIN

        --SELECT  F.FundID      
        --     ,F.FundName      
        --     ,F.FundManagementCompanyID      
        --     ,F.FundTypeID      
        --     ,F.FundDescription      
        --     ,F.FundCreationDate      
        --     ,F.FundAddress      
        --     ,F.FundZipCode      
        --     ,F.FundPOBox      
        --     ,F.CurrencyID      
        --     ,F.CountryID      
        --     ,F.CityID      
        --     ,F.ClosedOn      
        --     ,F.ReportingFrequencyID      
        --     ,F.ValuationModeID      
        --     ,F.FundLegalType      
        --     ,F.FundReportingGuidlines      
        --     ,F.FundDurationYears      
        --     ,F.FundDurationMonths      
        --     ,F.FundAdditionalYears      
        --     ,F.FundInvestmentPeriodMonths      
        --     ,F.FundInvestmentPeriodYears      
        --     ,F.FundLegalComments      
        --     ,F.FundFiscalComments      
        --     ,F.FundSwiftCode      
        --     ,F.FundIBANCode      
        --     ,F.FundCustodianCompanyID      
        --     ,F.FundInvestmentTypeID      
        --     ,F.FundNoOfForcastOperationFrom      
        --     ,F.FundNoOfForcastOperationTo      
        --     ,F.FundManagementFees      
        --     ,F.FundHurdleRate      
        --     ,F.FundCatchUp      
        --     ,F.FundCarriedIntrest      
        --     ,F.FundAccountName      
        --     ,F.FundAccountTypeID      
        --     ,F.FundAccountCode      
        --     ,F.FundAccountComments      
        --     ,F.IsMainFund      
        --     ,F.MainFundID      
        --     ,F.IsSubFund      
        --     ,F.SubFundRatio as FundRatio       
        --     ,F.ParentFundID      
        --     ,F.FundInvestmentSizeFrom      
        --     ,F.FundInvestmentSizeTo      
        --     ,F.IsContactfund ,      
        --     SF.SubFundID      
        --     ,SF.SubFundJurisdiction      
        --     ,SF.RatioBasedOnCommitments      
        --     ,SF.SubFundRatio      
        --     ,SF.HasOwnCCnDistribution      
        --     FROM [tbl_SubFunds] SF      
        --        inner join       
        -- tbl_Funds F       
        -- on sf.SubFundID  = F.FundID      
        -- WHERE sf.SubFundID=ISNULL(@SubFundID,SubFundID)  AND  F.ParentFundID = ISNULL(@ParentFundID,F.ParentFundID)      

        SELECT [SubFundID], 
               [SubFundName], 
               [ParentFundID], 
               [SubFundGroupID], 
               [SubFundJurisdiction],      
               --,[RatioBasedOnCommitments]       
               [SubFundRatio], 
               [HasOwnCCnDistribution], 
               ISNULL(
        (
            SELECT FundRatioRequired
            FROM [tbl_Funds]
            WHERE fundid = @ParentFundID
        ), 0) FundRatioRequired
        FROM [LBOffice].[dbo].[tbl_SubFunds]
        WHERE SubFundID = ISNULL(@SubFundID, SubFundID)
              AND ParentFundID = ISNULL(@ParentFundID, ParentFundID)
        ORDER BY SubFundID DESC;
    END;
