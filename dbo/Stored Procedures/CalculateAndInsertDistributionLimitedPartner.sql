
-- [CalculateAndInsertDistributionLimitedPartner] 196,1173,77,500.00,'01-02-2018','',''

CREATE PROCEDURE [dbo].[CalculateAndInsertDistributionLimitedPartner] @DistributionID INT, 
                                                                   @VehicleID      INT, 
                                                                   @ShareID        INT, 
                                                                   @Amount         FLOAT, 
                                                                   @date           DATETIME, 
                                                                   @CreatedBy      VARCHAR(200), 
                                                                   @ModifiedBy     VARCHAR(200)
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
               GROUP BY b.ShareID, 
                        a.ModuleID, 
                        a.ObjectID;
        INSERT INTO @LPCalculation
               SELECT MIN(t.LimitedPartnerID), 
                      VehicleShareID, 
                      -1 * SUM(ShareAmount) Amount, 
                      0
               FROM tbl_CommitmentTransfer lp
                    JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                    JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
                    JOIN tbl_LimitedPartner t ON lp.FromLPID = t.LimitedPartnerID
                                                 AND lp.FromModuleID = t.ModuleID
                                                 AND t.VehicleID = lp.FundID
               WHERE lp.FundID = @vehicleID
                     AND vs.VehicleShareID = @ShareID
                     AND lp.Date < @date
               GROUP BY VehicleShareID, 
                        lp.FromObjectID, 
                        lp.FromModuleID;
        INSERT INTO @LPCalculation
               SELECT MIN(t.LimitedPartnerID), 
                      VehicleShareID, 
                      SUM(ShareAmount) Amount, 
                      0
               FROM tbl_CommitmentTransfer lp
                    JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                    JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
                    LEFT JOIN tbl_LimitedPartner t ON lp.ToLPID = t.LimitedPartnerID
                                                      AND lp.ToModuleID = t.ModuleID
                                                      AND t.VehicleID = lp.FundID
               --          from tbl_CommitmentTransfer lp
               --               JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
               --               JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
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
        INSERT INTO tbl_DistributionLimitedPartner
               SELECT LPID, 
                      ShareID, 
                      SUM(FinalAmount), 
                      1, 
                      GETDATE(), 
                      GETDATE(), 
                      @CreatedBy, 
                      @ModifiedBy, 
                      @DistributionID, 
                      NULL
               FROM @LPCalculation
               GROUP BY LPID, 
                        ShareID, 
                        LPID;
        SELECT 1;
    END;
