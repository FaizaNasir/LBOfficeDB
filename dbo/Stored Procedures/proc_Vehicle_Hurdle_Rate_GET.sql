CREATE PROCEDURE [dbo].[proc_Vehicle_Hurdle_Rate_GET]            
-- Add the parameters for the stored procedure here            
@VehicleID    INT          = NULL, 
@HurdleRateID INT          = NULL, 
@RoleName     VARCHAR(100) = NULL
AS
    BEGIN
        SELECT HurdleRateID, 
               h.VehicleID, 
               Rate, 
               Capitalized, 
               StartDate, 
               EndDate, 
               Basis, 
               CreatedDateTime, 
               CreatedBy, 
               ModifiedDateTime, 
               ModifiedBy
        FROM [LBOffice].[dbo].[tbl_VehicleHurdleRate] h
        WHERE h.VehicleID = ISNULL(@VehicleID, h.VehicleID)
              AND HurdleRateID = ISNULL(@HurdleRateID, HurdleRateID);
    END;
