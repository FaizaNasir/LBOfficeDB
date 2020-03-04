CREATE PROCEDURE [dbo].[proc_Fund_Strategy_FinancialInstrument_GET] @FundID INT = NULL
AS
    BEGIN
        SELECT FundStrategyFinancialID, 
               tbl_FundStrategyFinancialInstrument.FinancialInstrumentID, 
               tbl_FundStrategyFinancialInstrument.CreatedDateTime, 
               'Type' = CASE IsInclude
                            WHEN '1'
                            THEN 'Include'
                            WHEN '0'
                            THEN 'Exclude'
                        END, 
               ModifiedDateTime, 
               Percentage, 
               IsInclude, 
               FundID, 
               CreatedBy, 
               ModifiedBy, 
               tbl_FinancialInstrument.FinancialInstrumentTitle
        FROM tbl_FundStrategyFinancialInstrument
             LEFT OUTER JOIN tbl_FinancialInstrument ON tbl_FundStrategyFinancialInstrument.FinancialInstrumentID = tbl_FinancialInstrument.FinancialInstrumentID
        WHERE FundID = ISNULL(@FundID, FundID);
    END;
