CREATE PROCEDURE [dbo].[proc_Deal_Fee_GET] --1       
@DealID INT = NULL
AS
    BEGIN
        SELECT DealFeeID, 
               Percentage, 
               AmountRaised, 
               DF.CurrencyID, 
               DF.Active, 
               DF.CreatedDateTime, 
               ModifiedDateTime, 
               DealID, 
               c.CurrencyCode, 
               IsEquity
        FROM tbl_DealFee DF
             LEFT JOIN [tbl_Currency] c ON c.CurrencyID = DF.CurrencyID
        WHERE DealID = ISNULL(@DealID, DealID);
    END;
