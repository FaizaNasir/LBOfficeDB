CREATE PROCEDURE [dbo].[proc_Interest_Appetite_Size_Preference_GET] @ObjectID  INT = NULL, 
                                                                    @IsCompany BIT = NULL
AS
    BEGIN
        SELECT [InterestSizePreferenceID], 
               [MinimumInvestmentSize], 
               tbl_InterestAppetiteSizePreference.[CurrencyID], 
               [MaximumInvestmentSize], 
               [ObjectID], 
               [CurrencyCode], 
               [CreatedBy], 
               [DateTime], 
               [IsCompany]
        FROM tbl_InterestAppetiteSizePreference
             LEFT OUTER JOIN tbl_Currency ON tbl_Currency.CurrencyID = tbl_InterestAppetiteSizePreference.CurrencyID
        WHERE ObjectID = ISNULL(@ObjectID, ObjectID)
              AND IsCompany = ISNULL(@IsCompany, IsCompany);
    END;
