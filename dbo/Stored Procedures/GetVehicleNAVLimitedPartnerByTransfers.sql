
-- GetCommitmentsLimitedPartnerByTransfers 1185,1089,3,5,461,1

CREATE PROC [dbo].[GetVehicleNAVLimitedPartnerByTransfers]
(@vehicleNAVID INT, 
 @vehicleID    INT, 
 @shareID      INT, 
 @moduleID     INT, 
 @objectID     INT, 
 @factorID     INT
)
AS
    BEGIN
        DECLARE @VehicleNavLimitedPartnerID INT;
        SELECT @VehicleNavLimitedPartnerID = VehicleNavLimitedPartnerID
        FROM tbl_vehiclenav c
             JOIN tbl_vehiclenavLimitedPartner cd ON cd.vehicleNAVID = c.vehicleNAVID
             JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = cd.LimitedPartnerID
        WHERE c.vehicleID = @vehicleID
              AND c.VehicleNavID = @vehicleNAVID
              AND cd.ShareID = @shareID
              AND lp.ModuleID = @moduleID
              AND lp.ObjectID = @objectID;
        SELECT @VehicleNavLimitedPartnerID Result;
    END;
