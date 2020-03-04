CREATE FUNCTION [dbo].[F_GetPartLiqVal]
(@fundID    INT, 
 @date      DATETIME, 
 @shareName VARCHAR(100)
)
RETURNS DECIMAL(18, 3)
AS
     BEGIN
         DECLARE @result DECIMAL(18, 3);
         SET @result =
         (
             SELECT TOP 1 NetAssetValue
             FROM tbl_VehicleShareDetail vsd
                  JOIN tbl_vehicleshare vs ON vs.VehicleShareID = vsd.shareID
             WHERE vsd.ShareDate <= @date
                   AND vs.VehicleID = @fundID
                   AND vs.ShareName = @shareName
             ORDER BY vsd.ShareDate DESC
         );
         RETURN ISNULL(@result, NULL);
     END;
