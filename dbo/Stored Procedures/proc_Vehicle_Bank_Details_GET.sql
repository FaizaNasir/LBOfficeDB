CREATE PROCEDURE [dbo].[proc_Vehicle_Bank_Details_GET] @VehicleID INT          = NULL, 
                                                       @RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT vbd.[VehicleBankDetailsID], 
               vbd.[VehicleID], 
               vbd.[AccountName], 
               vbd.[AccountNumber], 
               vbd.[AccountIBAN], 
               vbd.[BankSWIFT], 
               vbd.[AccountCurrencyID], 
               vbd.[CustodianID], 
               vbd.[CreatedDateTime], 
               vbd.[CreatedBy], 
               vbd.[ModifiedDateTime], 
               vbd.[ModifiedBy], 
               vbd.[Active], 
               c.[CurrencyID], 
               cc.CompanyName, 
               c.CurrencyCode, 
               ISNULL(BranchCode, '') AS BranchCode, 
               ISNULL(SortCode, '') AS SortCode, 
               ISNULL(RIBCode, '') AS RIBCode
        FROM [tbl_VehicleBankDetails] vbd
             JOIN tbl_companycontact cc ON cc.CompanyContactID = vbd.[CustodianID]
             JOIN tbl_currency c ON c.CurrencyID = vbd.AccountCurrencyID
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID);
    END;
