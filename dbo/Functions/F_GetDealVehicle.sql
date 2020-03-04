CREATE FUNCTION [dbo].[F_GetDealVehicle]
(@dealID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ',', '') + v.Name
         FROM tbl_Vehicle v
              JOIN tbl_DealVehicle dv ON dv.VehicleID = v.VehicleID
         WHERE dealid = @dealID;
         RETURN @VouvherNo;
     END;
