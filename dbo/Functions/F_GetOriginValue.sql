CREATE FUNCTION [dbo].[F_GetOriginValue]
(@id   INT, 
 @date DATETIME
)
RETURNS DECIMAL(18, 3)
AS
     BEGIN
         DECLARE @result DECIMAL(18, 3);
         SET @result =
         (
         (
             SELECT SUM(NumberofShare * NominalValue)
             FROM
             (
                 SELECT
                 (
                     SELECT TOP 1 NumberofShare
                     FROM tbl_VehicleShareDetail vd
                     WHERE vd.shareID = v.VehicleShareID
                           AND ShareDate <= @date
                     ORDER BY ShareDate DESC
                 ) NumberofShare, 
                 NominalValue
                 FROM tbl_vehicleshare v
                 WHERE vehicleID = @id
             ) t
         )
         );
         RETURN ISNULL(@result, NULL);
     END;
