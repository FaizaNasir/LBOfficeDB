CREATE PROCEDURE [dbo].[DeleteMultiCurrencyRate] @MultiCurrencyRateID INT = NULL
AS
    BEGIN
        DELETE FROM [tbl_MultiCurrencyRate]
        WHERE MultiCurrencyRateID = @MultiCurrencyRateID;
        SELECT 1;
    END;
