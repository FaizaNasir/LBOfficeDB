CREATE FUNCTION [dbo].[F_GetDealFund]
(@dealID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' / ', '') + cc.Name
         FROM tbl_DealVehicle dc
              JOIN tbl_Vehicle cc ON cc.VehicleId = dc.VehicleId
         WHERE dc.dealid = @dealID;
         RETURN @VouvherNo;
     END;
