CREATE FUNCTION [dbo].[F_GetPortfolioVehicle]
(@id INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @ConcatString VARCHAR(MAX);
         SELECT @ConcatString = COALESCE(@ConcatString + ', ', '') + name
         FROM tbl_portfoliovehicle pv
              JOIN tbl_vehicle v ON pv.VehicleID = v.VehicleID
         WHERE pv.PortfolioID = @id;
         RETURN
         (
             SELECT @ConcatString
         );
     END;
