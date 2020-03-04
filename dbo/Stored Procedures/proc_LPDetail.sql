-- proc_LPDetail

CREATE PROC [dbo].[proc_LPDetail]
(@vehicleID INT, 
 @objectID  INT, 
 @moduleID  INT
)
AS
    BEGIN
        IF @vehicleID = 0
            SET @vehicleID = NULL;
        DECLARE @tbl TABLE
        (ShareName      VARCHAR(100), 
         Amount         DECIMAL(18, 2), 
         VehicleShareID INT
        );
        INSERT INTO @tbl
               SELECT ShareName, 
                      SUM(Amount) * 1.0 Amount, 
                      VehicleShareID
               FROM tbl_LimitedPartnerDetail lpd
                    JOIN tbl_limitedpartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                    JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ShareID
               WHERE lp.ModuleID = @ModuleID
                     AND lp.ObjectID = @objectID
                     AND lp.VehicleID = ISNULL(@vehicleID, lp.VehicleID)
               GROUP BY ShareName, 
                        VehicleShareID;
        INSERT INTO @tbl
               SELECT ShareName, 
                      -1 * SUM(ShareAmount) * 1.0 Amount, 
                      VehicleShareID
               FROM tbl_CommitmentTransfer lp
                    JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                    JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
               WHERE lp.FundID = @vehicleID
                     AND lp.FromObjectID = @objectID
                     AND lp.FromModuleID = @moduleID
               GROUP BY ShareName, 
                        VehicleShareID;
        INSERT INTO @tbl
               SELECT ShareName, 
                      SUM(ShareAmount) * 1.0 Amount, 
                      VehicleShareID
               FROM tbl_CommitmentTransfer lp
                    JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                    JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
               WHERE lp.FundID = @vehicleID
                     AND lp.ToObjectID = @objectID
                     AND lp.ToModuleID = @moduleID
               GROUP BY ShareName, 
                        VehicleShareID;
        SELECT ShareName, 
               SUM(Amount) Amount, 
               VehicleShareID
        FROM @tbl t
        GROUP BY t.ShareName, 
                 VehicleShareID;
    END;
