CREATE PROC [dbo].[proc_CalculateVehicleRatio](@vehicleID INT)
AS
    BEGIN
        DECLARE @tblShareholdingID TABLE(ID INT);
        DECLARE @OriginValue INT;
        SET @OriginValue =
        (
            SELECT TOP 1 AssetsofOrigin
            FROM tbl_vehicleshare
            WHERE VehicleID = @VehicleID
        );
        INSERT INTO @tblShareholdingID
               SELECT ShareholdingOperationID
               FROM tbl_portfolioshareholdingoperations a
                    JOIN tbl_portfoliovehicle b ON a.portfolioID = b.portfolioID
               WHERE b.VehicleID = @vehicleID
                     AND a.ToID = b.VehicleID
                     AND a.ToTypeID = 3;
    END;
