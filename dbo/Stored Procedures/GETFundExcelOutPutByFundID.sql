CREATE PROCEDURE [dbo].[GETFundExcelOutPutByFundID] @FundID INT = NULL  
AS  
    BEGIN  
        SELECT ShareID,   
               TotalNAVCell,   
               NAVPerShareCell,   
               ReturnOfCapitalAmountCell,   
               ProfitsAmountCell,   
               vs.ShareName,   
               CarriedInterestCell,   
               InitialShareValueReimbursement,   
               PreferredReturn,   
               ACShares,   
               NetSurplusPaidInCash  
        FROM FundExcelOutput S  
             JOIN tbl_vehicleshare vs ON S.ShareID = vs.VehicleShareID  
        WHERE S.FundID = ISNULL(@FundID, S.FundID);  
    END;