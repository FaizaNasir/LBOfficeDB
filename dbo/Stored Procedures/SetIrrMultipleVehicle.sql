CREATE PROC [dbo].[SetIrrMultipleVehicle]
(@vehicleID     INT, 
 @irrGross      DECIMAL(18, 6), 
 @multipleGross DECIMAL(18, 6), 
 @irrNet        DECIMAL(18, 6), 
 @multipleNet   DECIMAL(18, 6)
)
AS
    BEGIN
        UPDATE tbl_vehicle
          SET 
              irrgross = @irrGross, 
              multiplegross = @multipleGross, 
              irrnet = @irrnet, 
              multiplenet = @multipleNet
        WHERE vehicleID = @vehicleID;
        SELECT 1 Result;
    END;
