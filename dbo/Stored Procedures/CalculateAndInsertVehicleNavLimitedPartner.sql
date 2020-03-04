CREATE PROCEDURE [dbo].[CalculateAndInsertVehicleNavLimitedPartner] @VehicleNavID INT, 
                                                                 @VehicleID    INT, 
                                                                 @ShareID      INT, 
                                                                 @Amount       FLOAT, 
                                                                 @date         DATETIME, 
                                                                 @CreatedBy    VARCHAR(200), 
                                                                 @ModifiedBy   VARCHAR(200)
AS
    BEGIN
        DECLARE @LPCalculation TABLE
        (LPID         INT, 
         ShareID      INT, 
         Committments DECIMAL(18, 5), 
         FinalAmount  DECIMAL(18, 5)
        );
        INSERT INTO @LPCalculation
               SELECT MAX(b.LimitedPartnerID), 
                      b.ShareID, 
                      SUM(ISNULL(amount, 0)) AS Amount, 
                      0
               FROM tbl_LimitedPartner a
                    JOIN tbl_LimitedPartnerDetail b ON a.LimitedPartnerID = b.LimitedPartnerID
               WHERE a.VehicleID = @VehicleID
                     AND b.ShareID = @ShareID
                     AND a.Date <= @date
                     AND a.ModuleID IS NOT NULL
                     AND a.ObjectID IS NOT NULL
               --and a.ObjectID = 3417
               GROUP BY b.ShareID, 
                        a.ModuleID, 
                        a.ObjectID;
        INSERT INTO @LPCalculation
               SELECT MIN(lp.FromLPID), 
                      VehicleShareID, 
                      -1 * SUM(ShareAmount) Amount, 
                      0
               FROM tbl_CommitmentTransfer lp
                    JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                                                AND lpd.FundShareID = @ShareID
                    JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
               --JOIN tbl_LimitedPartnerDetail td on td.LimitedPartnerID = lp.FromLPID
               --					  and td.ShareID = vs.VehicleShareID
               --JOIN tbl_LimitedPartner t ON td.LimitedPartnerID = t.LimitedPartnerID

               WHERE lp.FundID = @VehicleID
                     AND vs.VehicleShareID = @ShareID
                     AND lp.Date <= @date
               --and lp.FromObjectID = 3417
               GROUP BY VehicleShareID, 
                        lp.FromObjectID, 
                        lp.FromModuleID;
        INSERT INTO @LPCalculation
               SELECT MIN(lp.ToLPID), 
                      VehicleShareID, 
                      SUM(ShareAmount) Amount, 
                      0
               FROM tbl_CommitmentTransfer lp
                    JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                                                AND lpd.ToShareID = @ShareID
                    JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
               --JOIN tbl_LimitedPartner td on td.LimitedPartnerID = lp.ToLPID
               --LEFT JOIN tbl_LimitedPartnerDetail t ON td.LimitedPartnerID = t.LimitedPartnerID
               --and t.ShareID = vs.VehicleShareID

               WHERE lp.FundID = @VehicleID
                     AND vs.VehicleShareID = ISNULL(@shareID, vs.VehicleShareID)
                     AND lp.Date <= @date
               --and lp.ToObjectID = 3417
               GROUP BY VehicleShareID, 
                        lp.ToObjectID, 
                        lp.ToModuleID;
        UPDATE @LPCalculation
          SET 
              FinalAmount = (Committments /
        (
            SELECT TOP 1 a.NominalValue
            FROM tbl_vehicleshareDetail a
            WHERE a.VehicleID = @VehicleID
                  AND a.ShareID = @ShareID
                  AND a.ShareDate <= @date
            ORDER BY a.ShareDate DESC
        )) * @Amount;
        INSERT INTO tbl_VehicleNavLimitedPartner
               SELECT LPID, 
                      ShareID, 
                      SUM(FinalAmount), 
                      1, 
                      GETDATE(), 
                      GETDATE(), 
                      @CreatedBy, 
                      @ModifiedBy, 
                      @VehicleNavID, 
                      NULL
               FROM @LPCalculation
               GROUP BY LPID, 
                        ShareID;
        SELECT 1;
    END;
