CREATE PROCEDURE [dbo].[proc_Vehicle_Catchup_GET]            
-- Add the parameters for the stored procedure here            
@VehicleID INT          = NULL, 
@CatchupID INT          = NULL, 
@RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT CatchupID, 
               cu.VehicleID, 
               Rate, 
               Capitalized, 
               StartDate, 
               EndDate, 
               Basis, 
               CreatedDateTime, 
               CreatedBy, 
               ModifiedDateTime, 
               ModifiedBy
        FROM [LBOffice].[dbo].[tbl_VehicleCatchUp] cu
        WHERE cu.VehicleID = ISNULL(@VehicleID, cu.VehicleID)
              AND CatchupID = ISNULL(@CatchupID, CatchupID);
    END;
