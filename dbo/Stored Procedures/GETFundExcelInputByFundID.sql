CREATE PROCEDURE [dbo].[GETFundExcelInputByFundID] @FundID INT = NULL
AS
    BEGIN
        SELECT DateCell, 
               NavDistributionAmount, 
               CashFlowstartCell, 
               PaidCarriedInterest, 
               PendingCarriedInterest, 
               ShareID, 
               NumOfSharesCell, 
               CommitmentsCell, 
               CallsCell, 
               IncludingFees, 
               Undrawn, 
               DistributionsCell, 
               ReturnOfCapitalCell, 
               ShareCashFlowstartCell, 
               Recallable
        FROM FundExcelInputMaster S
             JOIN FundExcelInputDetail A ON S.FundID = A.FundID
        WHERE S.FundID = ISNULL(@FundID, S.FundID);
    END;
