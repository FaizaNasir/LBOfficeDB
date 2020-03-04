CREATE FUNCTION [dbo].[F_GetActivityName]
(@VehicleID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' / ', '') + A.ActiviteName
         FROM tbl_Vehicle V
              JOIN tbl_VehicleActivity VA ON VA.VehicleID = V.VehicleID
              JOIN tbl_Activities A ON VA.ActivityId = A.ActiviteID
         WHERE V.VehicleID = @VehicleID;

         --print @VouvherNo

         RETURN @VouvherNo;
     END;
