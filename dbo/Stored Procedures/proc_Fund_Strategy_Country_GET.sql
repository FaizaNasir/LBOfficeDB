CREATE PROCEDURE [dbo].[proc_Fund_Strategy_Country_GET] @FundID INT = NULL
AS
    BEGIN
        SELECT FundStrategyCountryID, 
               tbl_FundStrategyCountry.CountryID, 
               tbl_FundStrategyCountry.CreatedDateTime, 
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
               tbl_Country.CountryName
        FROM tbl_FundStrategyCountry
             LEFT OUTER JOIN tbl_Country ON tbl_FundStrategyCountry.CountryID = tbl_Country.CountryID
        WHERE FundID = ISNULL(@FundID, FundID);
    END;
