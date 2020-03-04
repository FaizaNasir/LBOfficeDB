CREATE PROCEDURE [dbo].[proc_Fund_Strategy_Investment_Criteria_GET] --1
@FundID INT = NULL
AS
    BEGIN
        SELECT [CriteriaID], 
               tbl_Fund_Strategy_Investment_Criteria.FundID, 
               [IsAndOr], 
               [ConditionSign], 
               tbl_Fund_Strategy_Investment_Criteria.InvestmentTypeID, 
               tbl_Fund_Strategy_Investment_Criteria.CurrencyID, 
               [Amount], 
               tbl_Currency.CurrencyCode, 
               tbl_InvestmentType.Title, 
               'Type' = CASE tbl_Fund_Strategy_Investment_Criteria.InvestmentTypeID
                            WHEN '3'
                            THEN 'employees'
                            ELSE tbl_Currency.CurrencyCode
                        END
        FROM tbl_Fund_Strategy_Investment_Criteria
             LEFT OUTER JOIN tbl_Currency ON tbl_Fund_Strategy_Investment_Criteria.CurrencyID = tbl_Currency.CurrencyID
             LEFT OUTER JOIN tbl_InvestmentType ON tbl_Fund_Strategy_Investment_Criteria.InvestmentTypeID = tbl_InvestmentType.InvestmentTypeID
        WHERE FundID = ISNULL(@FundID, FundID);
    END;
