CREATE PROCEDURE [dbo].[proc_FundBankDetails_GET] @FundID            INT, 
                                                  @FundBankDetailsID INT
AS
    BEGIN
        SELECT [FundBankDetailsID], 
               [FundID], 
               [AccountName], 
               [AccountNumber], 
               [IBAN], 
               [SWIFT], 
               c.[CurrencyID], 
               [CustodianID], 
               cc.CompanyName, 
               CurrencyCode, 
               CurrencyCountry
        FROM [LBOffice].[dbo].[tbl_FundBankDetails] fbd
             JOIN tbl_companycontact cc ON cc.CompanyContactID = fbd.[CustodianID]
             JOIN tbl_currency c ON c.CurrencyID = fbd.CurrencyID
        WHERE FundID = ISNULL(@FundID, FundID)
              AND FundBankDetailsID = ISNULL(@FundBankDetailsID, FundBankDetailsID);
    END;
