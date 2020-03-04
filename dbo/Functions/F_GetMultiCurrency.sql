CREATE FUNCTION [dbo].[F_GetMultiCurrency]
(@date     DATETIME, 
 @currency VARCHAR(20)
)
RETURNS DECIMAL(18, 10)
AS
     BEGIN
         DECLARE @return_value DECIMAL(18, 10);
         SET @return_value =
         (
             SELECT TOP 1 rate
             FROM tbl_MultiCurrencyRate
             WHERE currencyID = @currency
                   AND Date <= @date
             ORDER BY date DESC
         );
         RETURN @return_value;
     END;
