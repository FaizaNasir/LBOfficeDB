CREATE PROC [dbo].[GetNumerOfShares]
(@vehicleID INT, 
 @shareID   INT, 
 @date      DATETIME
)
AS
     DECLARE @nominalVal NUMERIC(25, 12);
     SET @nominalVal =
     (
         SELECT TOP 1 a.NominalValue
         FROM tbl_vehicleshareDetail a
         WHERE a.VehicleID = @VehicleID
               AND a.ShareID = @ShareID
               AND a.ShareDate <= @date
         ORDER BY a.ShareDate DESC
     );
     SELECT SUM(amount) / @nominalVal Val, 
            shareid, 
            a.vehicleid, 
            @nominalVal NominalValue
     FROM tbl_limitedpartner a
          JOIN tbl_limitedpartnerdetail b ON a.limitedpartnerid = b.limitedpartnerid
     WHERE a.VehicleID = ISNULL(@vehicleID, a.VehicleID)
           AND b.ShareID = ISNULL(@shareID, b.ShareID)
           AND a.Date <= @date
     GROUP BY shareid, 
              a.vehicleid;
