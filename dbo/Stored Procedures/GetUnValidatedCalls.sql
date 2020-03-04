CREATE PROC [dbo].[GetUnValidatedCalls]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        SELECT CapitalCallID, 
               DueDate, 
               CallDate
        FROM tbl_CapitalCall c
        WHERE c.FundID = @vehicleID
              AND c.CallDate <= @date;
        --and 1 = case when TotalValidationReq = 1 and Log1 is null then 1
        --when TotalValidationReq = 2 and Log2 is null then 1 else 0 end

    END;
