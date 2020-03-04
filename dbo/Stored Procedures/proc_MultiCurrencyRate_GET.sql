CREATE PROCEDURE [dbo].[proc_MultiCurrencyRate_GET]
AS
    BEGIN
        SELECT mcr.[MultiCurrencyRateID], 
               mcr.[CurrencyID] CurrencyCode, 
               mcr.[Date], 
               mcr.[Rate], 
               mcr.[Active], 
               mcr.[CreatedDateTime], 
               mcr.[ModifiedDateTime], 
               mcr.[CreatedBy], 
               mcr.[ModifiedBy]
        FROM [tbl_MultiCurrencyRate] mcr;
    END;
