CREATE PROC GetTotalCommitmentsByFund
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        SELECT ShareID, 
               ShareName, 
               SUM(Amount) Amount
        FROM tbl_LimitedPartner lp
             JOIN tbl_LimitedPartnerDetail lpd ON lp.limitedpartnerID = lpd.limitedpartnerID
             JOIN tbl_vehicleshare vs ON vs.VehicleShareID = lpd.ShareID
                                         AND vs.VehicleID = lp.VehicleID
        WHERE lp.VehicleID = @vehicleID
              AND lp.Date <= @date
			  and lp.ModuleID <> 0
              --AND vs.IncludedReport = 1
        GROUP BY ShareID, 
                 ShareName;
    END;