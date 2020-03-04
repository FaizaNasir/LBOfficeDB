
-- [proc_tbl_CapitalCallOperation_GET_By_CapitalCallID] 12

CREATE PROCEDURE [dbo].[proc_tbl_CapitalCallOperation_GET_By_CapitalCallID] @CapitalCallID INT = NULL
AS
    BEGIN
        SELECT s.CapitalCallOperationID, 
               s.FundID, 
               s.Date, 
               s.Type, 
               s.ShareID, 
               vs.VehicleShareID, 
               vs.ShareName, 
               CAST(InvestmentAmount AS DECIMAL(18, 2)) AS InvestmentAmount, 
               CAST(ManagementFees AS DECIMAL(18, 2)) AS ManagementFees, 
               CAST(OtherFees AS DECIMAL(18, 2)) AS OtherFees, 
               S.Active, 
               S.CreatedDateTime, 
               S.ModifiedDateTime, 
               S.CreatedBy, 
               S.ModifiedBy
        FROM tbl_CapitalCallOperation S
             LEFT JOIN tbl_vehicleshare vs ON S.ShareID = vs.VehicleShareID
        WHERE S.CapitalCallID = @CapitalCallID;
    END;
