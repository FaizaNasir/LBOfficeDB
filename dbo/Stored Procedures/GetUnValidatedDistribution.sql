CREATE PROC [dbo].[GetUnValidatedDistribution]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        SELECT DistributionID, 
               Date
        FROM tbl_Distribution c
        WHERE c.FundID = @vehicleID
              AND c.Date <= @date;
        --and 1 = case when TotalValidationReq = 1 and Log1 is null then 1
        --when TotalValidationReq = 2 and Log2 is null then 1 else 0 end

    END;
