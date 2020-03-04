CREATE PROCEDURE [dbo].[proc_CalculateCapitalCallLimitedPartner_Get] @VehicleID INT, 
                                                                    @ShareID   INT, 
                                                                    @Amount    DECIMAL(18, 2), 
                                                                    @closingID INT, 
                                                                    @calldate  DATETIME
AS
    BEGIN
        DECLARE @dateFrom DATETIME, @dateTo DATETIME;
        SELECT @dateFrom = StartDate, 
               @dateTo = EndDate
        FROM tbl_vehicleclosing
        WHERE VehicleClosingID = @closingID;
        IF @dateFrom IS NULL
            SET @dateFrom = '01/01/1900';
        IF @dateTo IS NULL
            SET @dateTo = @calldate;
        DECLARE @LPCalculation TABLE
        (LPID           INT, 
         ShareID        INT, 
         AmountCommited FLOAT, 
         Percentage     FLOAT, 
         CallAmount     FLOAT, 
         ObjectID       INT, 
         ModuleID       INT
        );
        INSERT INTO @LPCalculation
               SELECT MIN(b.LimitedPartnerID), 
                      b.ShareID, 
                      SUM(ISNULL(amount, 0)) AS Amount, 
                      0, 
                      0, 
                      ObjectID, 
                      ModuleID
               FROM tbl_LimitedPartner a
                    JOIN tbl_LimitedPartnerDetail b ON a.LimitedPartnerID = b.LimitedPartnerID
               WHERE a.VehicleID = @VehicleID
                     AND b.ShareID = @ShareID
                     AND a.Date BETWEEN @dateFrom AND @dateTo
                     AND a.ModuleID IS NOT NULL
                     AND a.ObjectID IS NOT NULL
               GROUP BY b.ShareID, 
                        a.ModuleID, 
                        a.ObjectID;
        INSERT INTO @LPCalculation
               SELECT MIN(t.LimitedPartnerID), 
                      VehicleShareID, 
                      -1 * SUM(ShareAmount) Amount, 
                      0, 
                      0, 
                      lp.FromObjectID, 
                      lp.FromModuleID
               FROM tbl_CommitmentTransfer lp
                    JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                    JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
                    JOIN tbl_LimitedPartner t ON lp.FromLPID = t.LimitedPartnerID
                                                 AND lp.FromModuleID = t.ModuleID
                                                 AND t.VehicleID = lp.FundID
               WHERE lp.FundID = @vehicleID
                     AND vs.VehicleShareID = @ShareID
                     AND lp.Date BETWEEN @dateFrom AND @dateTo
               GROUP BY VehicleShareID, 
                        lp.FromObjectID, 
                        lp.FromModuleID;
        INSERT INTO @LPCalculation
               SELECT MIN(t.LimitedPartnerID), 
                      VehicleShareID, 
                      SUM(ShareAmount) Amount, 
                      0, 
                      0, 
                      lp.ToObjectID, 
                      lp.ToModuleID
               FROM tbl_CommitmentTransfer lp
                    JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                    JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
                    LEFT JOIN tbl_LimitedPartner t ON lp.ToLPID = t.LimitedPartnerID
                                                      AND lp.ToModuleID = t.ModuleID
                                                      AND t.VehicleID = lp.FundID
               WHERE lp.FundID = @vehicleID
                     AND vs.VehicleShareID = @ShareID
                     AND lp.Date BETWEEN @dateFrom AND @dateTo
               GROUP BY VehicleShareID, 
                        lp.ToObjectID, 
                        lp.ToModuleID;
        --select * from @LPCalculation
        UPDATE @LPCalculation
          SET 
              Percentage = (AmountCommited / CAST(
        (
            SELECT CASE SUM(ISNULL(AmountCommited, 0.000000000000000000))
                       WHEN 0
                       THEN 1
                       ELSE SUM(ISNULL(AmountCommited, 0.000000000000000000))
                   END
            FROM @LPCalculation
        ) AS FLOAT));
        UPDATE @LPCalculation
          SET 
              CallAmount = (CAST(@Amount AS FLOAT) * Percentage);
        SELECT *
        FROM
        (
            SELECT LPID, 
                   ShareID, 
                   ObjectID, 
                   ModuleID, 
                   SUM(Amountcommited) Amountcommited, 
                   SUM(Percentage) Percentage, 
                   SUM(CallAmount) CallAmount
            FROM @LPCalculation
            GROUP BY LPID, 
                     ShareID, 
                     ObjectID, 
                     ModuleID
        ) t;
        --WHERE CallAmount > 0;
    END;
