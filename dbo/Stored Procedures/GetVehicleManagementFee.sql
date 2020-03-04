CREATE PROC [dbo].[GetVehicleManagementFee]
(@vehicleManagementFeeID INT, 
 @vehicleID              INT
)
AS
    BEGIN
        SELECT VehicleManagementFeeID, 
               VehicleID, 
               Commitment, 
               BasisPeriod, 
               FeesReceivedByGP, 
               Date, 
               Active, 
               CreatedDate, 
               ModifiedDate, 
               CreatedBy, 
               ModifiedBy, 
               AcquisitionCost, 
               InvestmentAmount, 
               TotalAmount
        FROM tbl_VehicleManagementFee
        WHERE vehicleid = @vehicleID
              AND vehicleManagementFeeID = ISNULL(vehicleManagementFeeID, @vehicleManagementFeeID)
        ORDER BY date DESC;
    END;