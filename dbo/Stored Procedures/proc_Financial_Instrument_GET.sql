CREATE PROCEDURE [dbo].[proc_Financial_Instrument_GET]
AS
    BEGIN
        SELECT [FinancialInstrumentID], 
               [FinancialInstrumentTitle], 
               [FinancialInstrumentDesc], 
               [Active], 
               [CreatedDateTime]
        FROM tbl_FinancialInstrument;
    END;
