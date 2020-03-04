CREATE PROC [dbo].[GetUnValidatedFundNAV]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        SELECT VehicleNavID, 
               NavDate
        FROM tbl_VehicleNav c
        WHERE c.VehicleID = @vehicleID
              AND c.NavDate <= @date;
        --and 1 = case when TotalValidationReq = 1 and Log1 is null then 1
        --when TotalValidationReq = 2 and Log2 is null then 1 else 0 end

    END;
