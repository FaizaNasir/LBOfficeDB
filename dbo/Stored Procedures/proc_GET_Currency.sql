-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_GET_Currency] @CurrencyID      INT          = NULL, 
                                           @CurrencyCode    VARCHAR(50)  = NULL, 
                                           @CurrencyCountry VARCHAR(100) = NULL
AS
    BEGIN
        SELECT *
        FROM tbl_Currency
        WHERE CurrencyID = ISNULL(@CurrencyID, CurrencyID)
              AND CurrencyCode = ISNULL(@CurrencyCode, CurrencyCode)
              AND CurrencyCountry = ISNULL(@CurrencyCountry, CurrencyCountry);
    END;
