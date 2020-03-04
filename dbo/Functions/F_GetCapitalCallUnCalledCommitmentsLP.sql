
-- select dbo.F_GetCapitalCallUnCalledCommitmentsLP(126,1150,12461,4,30,'2017-09-11')

CREATE FUNCTION [dbo].[F_GetCapitalCallUnCalledCommitmentsLP]
(@capitalCallID INT, 
 @vehicleID     INT, 
 @objectID      INT, 
 @moduleID      INT, 
 @shareID       INT, 
 @date          DATETIME
)
RETURNS DECIMAL(25, 3)
AS
     BEGIN
         --Undrawn last NAV of that LP – capital calls after last nav date + distributions after last nav date = 63,630 – 11,970 – 11,550 = 40,110
         --DECLARE  @capitalCallID INT
         --DECLARE @vehicleID     INT
         --DECLARE @objectID      INT
         --DECLARE @moduleID      INT
         --DECLARE @shareID       INT
         --DECLARE @date          DATETIME
         --set @capitalCallID = 127
         -- set @vehicleID = 1150
         --  set @objectID = 12461
         --   set @moduleID = 4
         -- set @shareID = 30
         --  set @date = '11-08-2017'

         DECLARE @return_value NUMERIC(25, 12);
         SET @return_value = 1;
         DECLARE @dateNAV DATETIME;
         DECLARE @amount NUMERIC(25, 12);
         DECLARE @dateDist DATETIME;
         DECLARE @totalSharesA NUMERIC(25, 12);
         DECLARE @totalSharesLP NUMERIC(25, 12);
         DECLARE @nominalVal NUMERIC(25, 12);
         DECLARE @undrawnSharesA NUMERIC(25, 12);
         DECLARE @takenFrom VARCHAR(100);
         DECLARE @vehicleNAVID INT;
         DECLARE @distributionID INT;
         DECLARE @big DATETIME;
         DECLARE @small DATETIME;
         --SET @date =
         --(
         --    SELECT calldate
         --    FROM tbl_CapitalCall
         --    WHERE CapitalCallID = @capitalCallID
         --);
         SET @totalSharesA =
         (
             SELECT SUM(amount)
             FROM tbl_LimitedPartner a
                  JOIN tbl_LimitedPartnerDetail b ON a.LimitedPartnerID = b.LimitedPartnerID
             WHERE a.VehicleID = @vehicleID
                   AND b.shareID = @shareID
                   AND a.date <= @date
         );
         SET @totalSharesLP = ISNULL(
         (
             SELECT SUM(amount)
             FROM tbl_LimitedPartner a
                  JOIN tbl_LimitedPartnerDetail b ON a.LimitedPartnerID = b.LimitedPartnerID
             WHERE a.VehicleID = @vehicleID
                   AND a.moduleID = @moduleID
                   AND a.objectid = @objectid
                   AND a.date <= @date
                   AND b.shareID = @shareID
         ), 0) + ISNULL(
         (
             SELECT-1 * SUM(ShareAmount)
             FROM tbl_CommitmentTransfer lp
                  JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                  JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
                  JOIN tbl_LimitedPartner t ON lp.FromLPID = t.LimitedPartnerID
                                               AND lp.FromModuleID = t.ModuleID
                                               AND t.VehicleID = lp.FundID
             WHERE lp.FundID = @vehicleID
                   AND vs.VehicleShareID = @ShareID
                   AND lp.Date <= @date
                   --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                   AND lp.FromObjectID = @objectID
                   AND lp.FromModuleID = @moduleID
         ), 0) + ISNULL(
         (
             SELECT SUM(ShareAmount)
             FROM tbl_CommitmentTransfer lp
                  JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                  JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
                  LEFT JOIN tbl_LimitedPartner t ON lp.ToLPID = t.LimitedPartnerID
                                                    AND lp.ToModuleID = t.ModuleID
                                                    AND t.VehicleID = lp.FundID
             WHERE lp.FundID = @VehicleID
                   AND vs.VehicleShareID = ISNULL(@shareID, vs.VehicleShareID)
                   AND lp.Date <= @date
                   --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                   AND lp.ToObjectID = @objectID
                   AND lp.ToModuleID = @moduleID
         ), 0);
         SET @nominalVal = ISNULL(
         (
             SELECT NominalValue
             FROM tbl_vehicleshare
             WHERE vehicleShareID = @shareID
         ), 0);
         IF @nominalVal > 0
             BEGIN
                 SET @totalSharesA = ISNULL(@totalSharesA / @nominalVal, 0);
                 SET @totalSharesLP = ISNULL(@totalSharesLP / @nominalVal, 0);
         END;
         SELECT TOP 1 @vehicleNAVID = vehicleNAVID, 
                      @dateNAV = navdate
         FROM tbl_vehiclenav
         WHERE VehicleID = @vehicleID
               AND navdate <= @date
         ORDER BY navdate DESC;
         SELECT TOP 1 @dateDist = Date, 
                      @distributionID = distributionID
         FROM tbl_distribution
         WHERE FundID = @vehicleID
               AND Date <= @date
         ORDER BY Date DESC;
         IF @dateNAV IS NULL
            AND @dateDist IS NULL
             BEGIN
                 SET @return_value = 0;
                 SET @amount = 0;
         END;
         IF(@return_value <> 0)
             BEGIN
                 IF(@dateNAV < @dateDist)
                     BEGIN
                         SET @big = @dateDist;
                         SET @small = @dateNAV;
                 END;
                     ELSE
                     BEGIN
                         SET @big = @dateNAV;
                         SET @small = @dateDist;
                 END;
                 IF(@date >= @big)
                     BEGIN
                         IF(@big = @dateNAV)
                             SET @takenFrom = 'NAV';
                             ELSE
                             IF(@big = @dateDist)
                                 SET @takenFrom = 'DIST';
                 END;
                     ELSE
                     IF(@date >= @small)
                         BEGIN
                             IF(@small = @dateNAV)
                                 SET @takenFrom = 'NAV';
                                 ELSE
                                 IF(@small = @dateDist)
                                     SET @takenFrom = 'DIST';
                     END;
                 IF @takenFrom = 'NAV'
                     BEGIN
                         SET @totalSharesA =
                         (
                             SELECT SUM(amount)
                             FROM tbl_LimitedPartner a
                                  JOIN tbl_LimitedPartnerDetail b ON a.LimitedPartnerID = b.LimitedPartnerID
                             WHERE a.VehicleID = @vehicleID
                                   AND b.shareID = @shareID
                                   AND a.date <= @dateNAV
                         );
                         SET @undrawnSharesA = ISNULL(
                         (
                             SELECT Undrawn
                             FROM tbl_VehicleNavDetails vnd
                             WHERE VehicleNavID = @VehicleNavID
                                   AND shareID = @shareID
                                   AND EXISTS
                             (
                                 SELECT TOP 1 1
                                 FROM tbl_VehicleNavLimitedPartner vlp
                                      JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
                                 WHERE vlp.vehiclenavid = vnd.VehicleNavID
                                       AND lp.ObjectID = @objectID
                                       AND lp.ModuleID = @moduleID
                                       AND vlp.ShareID = @shareID
                             )
                         ), 0);
                         SET @totalSharesA = ISNULL(@undrawnSharesA, 0) / @totalSharesA;
                         SET @return_value = CAST(@totalSharesA * @totalSharesLP AS NUMERIC(25, 12));
                         IF
                         (
                             SELECT Undrawn
                             FROM tbl_VehicleNavDetails
                             WHERE VehicleNavID = @VehicleNavID
                                   AND shareID = @shareID
                         ) IS NOT NULL
                             BEGIN
                                 SET @return_value = @return_value + ISNULL(
                                 (
                                     SELECT SUM(amount * 1.0000000000000000)
                                     FROM tbl_limitedpartnerdetail lpd
                                          JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                     WHERE lp.ObjectID = @objectID
                                           AND lp.ModuleID = @moduleID
                                           AND lp.VehicleID = @vehicleID
                                           AND lpd.ShareID = @shareID
                                           AND lp.Date BETWEEN @dateNAV AND @date
                                 ), 0) + ISNULL(
                                 (
                                     SELECT-1 * SUM(ShareAmount)
                                     FROM tbl_CommitmentTransfer lp
                                          JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                          JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
                                          JOIN tbl_LimitedPartner t ON lp.FromLPID = t.LimitedPartnerID
                                                                       AND lp.FromModuleID = t.ModuleID
                                                                       AND t.VehicleID = lp.FundID
                                     WHERE lp.FundID = @vehicleID
                                           AND vs.VehicleShareID = @ShareID
                                           AND lp.Date BETWEEN @dateNAV AND @date
                                           --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                                           AND lp.FromObjectID = @objectID
                                           AND lp.FromModuleID = @moduleID
                                 ), 0) + ISNULL(
                                 (
                                     SELECT SUM(ShareAmount)
                                     FROM tbl_CommitmentTransfer lp
                                          JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                          JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
                                          LEFT JOIN tbl_LimitedPartner t ON lp.ToLPID = t.LimitedPartnerID
                                                                            AND lp.ToModuleID = t.ModuleID
                                                                            AND t.VehicleID = lp.FundID
                                     WHERE lp.FundID = @VehicleID
                                           AND vs.VehicleShareID = ISNULL(@shareID, vs.VehicleShareID)
                                           AND lp.Date BETWEEN @dateNAV AND @date
                                           --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                                           AND lp.ToObjectID = @objectID
                                           AND lp.ToModuleID = @moduleID
                                 ), 0);
                                 SET @amount = ISNULL(
                                 (
                                     SELECT SUM(amount * 1.0000000000000000)
                                     FROM tbl_CapitalCall a
                                          JOIN tbl_CapitalCallLimitedPartner b ON a.Capitalcallid = b.Capitalcallid
                                          JOIN tbl_limitedpartner c ON c.LimitedPartnerID = b.LimitedPartnerID
                                     WHERE a.CallDate BETWEEN @dateNAV AND @date
                                           AND b.ShareID = @shareID
                                           AND c.objectid = @objectid
                                           AND c.moduleid = @moduleID
                                 ), 0);
                         END;
                             ELSE
                             BEGIN
                                 BEGIN
                                     SET @amount = ISNULL(
                                     (
                                         SELECT SUM(amount * 1.0000000000000000)
                                         FROM tbl_CapitalCall a
                                              JOIN tbl_CapitalCallLimitedPartner b ON a.Capitalcallid = b.Capitalcallid
                                              JOIN tbl_limitedpartner c ON c.LimitedPartnerID = b.LimitedPartnerID
                                         WHERE a.CallDate <= @date
                                               AND b.ShareID = @shareID
                                               AND c.objectid = @objectid
                                               AND c.moduleid = @moduleID
                                     ), 0);
                                     SET @return_value = @return_value + ISNULL(
                                     (
                                         SELECT SUM(amount * 1.0000000000000000)
                                         FROM tbl_limitedpartnerdetail lpd
                                              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                         WHERE lp.ObjectID = @objectID
                                               AND lp.ModuleID = @moduleID
                                               AND lp.VehicleID = @vehicleID
                                               AND lpd.ShareID = @shareID
                                               AND lp.Date <= @date
                                     ), 0) + ISNULL(
                                     (
                                         SELECT-1 * SUM(ShareAmount)
                                         FROM tbl_CommitmentTransfer lp
                                              JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                              JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
                                              JOIN tbl_LimitedPartner t ON lp.FromLPID = t.LimitedPartnerID
                                                                           AND lp.FromModuleID = t.ModuleID
                                                                           AND t.VehicleID = lp.FundID
                                         WHERE lp.FundID = @vehicleID
                                               AND vs.VehicleShareID = @ShareID
                                               AND lp.Date <= @date
                                               --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                                               AND lp.FromObjectID = @objectID
                                               AND lp.FromModuleID = @moduleID
                                     ), 0) + ISNULL(
                                     (
                                         SELECT SUM(ShareAmount)
                                         FROM tbl_CommitmentTransfer lp
                                              JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                              JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
                                              LEFT JOIN tbl_LimitedPartner t ON lp.ToLPID = t.LimitedPartnerID
                                                                                AND lp.ToModuleID = t.ModuleID
                                                                                AND t.VehicleID = lp.FundID
                                         WHERE lp.FundID = @VehicleID
                                               AND vs.VehicleShareID = ISNULL(@shareID, vs.VehicleShareID)
                                               AND lp.Date <= @date
                                               --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                                               AND lp.ToObjectID = @objectID
                                               AND lp.ToModuleID = @moduleID
                                     ), 0);
                         END;
                         END;
                 END;
                     ELSE
                     IF @takenFrom = 'DIST'
                         BEGIN
                             SET @totalSharesA =
                             (
                                 SELECT SUM(amount)
                                 FROM tbl_LimitedPartner a
                                      JOIN tbl_LimitedPartnerDetail b ON a.LimitedPartnerID = b.LimitedPartnerID
                                 WHERE a.VehicleID = @vehicleID
                                       AND b.shareID = @shareID
                                       AND a.date <= @dateDist
                             );
                             SET @undrawnSharesA = ISNULL(
                             (
                                 SELECT Undrawn
                                 FROM tbl_DistributionOperation vnd
                                 WHERE DistributionID = @DistributionID
                                       AND shareID = @shareID
                                       AND EXISTS
                                 (
                                     SELECT TOP 1 1
                                     FROM tbl_DistributionLimitedPartner vlp
                                          JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
                                     WHERE vlp.DistributionID = vnd.DistributionID
                                           AND lp.ObjectID = @objectID
                                           AND lp.ModuleID = @moduleID
                                           AND vlp.ShareID = @shareID
                                 )
                             ), 0);
                             SET @totalSharesA = ISNULL(@undrawnSharesA, 0) / @totalSharesA;
                             SET @return_value = CAST(@totalSharesA * @totalSharesLP AS NUMERIC(25, 12));
                             IF
                             (
                                 SELECT Undrawn
                                 FROM tbl_DistributionOperation
                                 WHERE DistributionID = @DistributionID
                                       AND shareID = @shareID
                             ) IS NOT NULL
                                 BEGIN
                                     SET @amount = ISNULL(
                                     (
                                         SELECT SUM(amount * 1.0000000000000000)
                                         FROM tbl_CapitalCall a
                                              JOIN tbl_CapitalCallLimitedPartner b ON a.Capitalcallid = b.Capitalcallid
                                              JOIN tbl_limitedpartner c ON c.LimitedPartnerID = b.LimitedPartnerID
                                         WHERE a.CallDate BETWEEN @dateDist AND @date
                                               AND b.ShareID = @shareID
                                               AND c.objectid = @objectid
                                               AND c.moduleid = @moduleID
                                     ), 0);
                                     SET @return_value = @return_value + ISNULL(
                                     (
                                         SELECT SUM(amount * 1.0000000000000000)
                                         FROM tbl_limitedpartnerdetail lpd
                                              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                         WHERE lp.ObjectID = @objectID
                                               AND lp.ModuleID = @moduleID
                                               AND lp.VehicleID = @vehicleID
                                               AND lpd.ShareID = @shareID
                                               AND lp.Date BETWEEN @dateDist AND @date
                                     ), 0) + ISNULL(
                                     (
                                         SELECT-1 * SUM(ShareAmount)
                                         FROM tbl_CommitmentTransfer lp
                                              JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                              JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
                                              JOIN tbl_LimitedPartner t ON lp.FromLPID = t.LimitedPartnerID
                                                                           AND lp.FromModuleID = t.ModuleID
                                                                           AND t.VehicleID = lp.FundID
                                         WHERE lp.FundID = @vehicleID
                                               AND vs.VehicleShareID = @ShareID
                                               AND lp.Date BETWEEN @dateDist AND @date
                                               --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                                               AND lp.FromObjectID = @objectID
                                               AND lp.FromModuleID = @moduleID
                                     ), 0) + ISNULL(
                                     (
                                         SELECT SUM(ShareAmount)
                                         FROM tbl_CommitmentTransfer lp
                                              JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                              JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
                                              LEFT JOIN tbl_LimitedPartner t ON lp.ToLPID = t.LimitedPartnerID
                                                                                AND lp.ToModuleID = t.ModuleID
                                                                                AND t.VehicleID = lp.FundID
                                         WHERE lp.FundID = @VehicleID
                                               AND vs.VehicleShareID = ISNULL(@shareID, vs.VehicleShareID)
                                               AND lp.Date BETWEEN @dateDist AND @date
                                               --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                                               AND lp.ToObjectID = @objectID
                                               AND lp.ToModuleID = @moduleID
                                     ), 0);
                             END;
                                 ELSE
                                 BEGIN
                                     SET @amount = ISNULL(
                                     (
                                         SELECT SUM(amount * 1.0000000000000000)
                                         FROM tbl_CapitalCall a
                                              JOIN tbl_CapitalCallLimitedPartner b ON a.Capitalcallid = b.Capitalcallid
                                              JOIN tbl_limitedpartner c ON c.LimitedPartnerID = b.LimitedPartnerID
                                         WHERE a.CallDate <= @date
                                               AND b.ShareID = @shareID
                                               AND c.objectid = @objectid
                                               AND c.moduleid = @moduleID
                                     ), 0);
                                     SET @return_value = @return_value + ISNULL(
                                     (
                                         SELECT SUM(amount * 1.0000000000000000)
                                         FROM tbl_limitedpartnerdetail lpd
                                              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                         WHERE lp.ObjectID = @objectID
                                               AND lp.ModuleID = @moduleID
                                               AND lp.VehicleID = @vehicleID
                                               AND lpd.ShareID = @shareID
                                               AND lp.Date <= @date
                                     ), 0) + ISNULL(
                                     (
                                         SELECT-1 * SUM(ShareAmount)
                                         FROM tbl_CommitmentTransfer lp
                                              JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                              JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
                                              JOIN tbl_LimitedPartner t ON lp.FromLPID = t.LimitedPartnerID
                                                                           AND lp.FromModuleID = t.ModuleID
                                                                           AND t.VehicleID = lp.FundID
                                         WHERE lp.FundID = @vehicleID
                                               AND vs.VehicleShareID = @ShareID
                                               AND lp.Date <= @date
                                               --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                                               AND lp.FromObjectID = @objectID
                                               AND lp.FromModuleID = @moduleID
                                     ), 0) + ISNULL(
                                     (
                                         SELECT SUM(ShareAmount)
                                         FROM tbl_CommitmentTransfer lp
                                              JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                              JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
                                              LEFT JOIN tbl_LimitedPartner t ON lp.ToLPID = t.LimitedPartnerID
                                                                                AND lp.ToModuleID = t.ModuleID
                                                                                AND t.VehicleID = lp.FundID
                                         WHERE lp.FundID = @VehicleID
                                               AND vs.VehicleShareID = ISNULL(@shareID, vs.VehicleShareID)
                                               AND lp.Date <= @date
                                               --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                                               AND lp.ToObjectID = @objectID
                                               AND lp.ToModuleID = @moduleID
                                     ), 0);
                             END;
                     END;
         END;
             ELSE
             BEGIN
                 SET @amount = ISNULL(
                 (
                     SELECT SUM(amount * 1.0000000000000000)
                     FROM tbl_CapitalCall a
                          JOIN tbl_CapitalCallLimitedPartner b ON a.Capitalcallid = b.Capitalcallid
                          JOIN tbl_limitedpartner c ON c.LimitedPartnerID = b.LimitedPartnerID
                     WHERE a.CallDate <= @date
                           AND b.ShareID = @shareID
                           AND c.objectid = @objectid
                           AND c.moduleid = @moduleID
                 ), 0);
                 SET @return_value = @return_value + ISNULL(
                 (
                     SELECT SUM(amount * 1.0000000000000000)
                     FROM tbl_limitedpartnerdetail lpd
                          JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                     WHERE lp.ObjectID = @objectID
                           AND lp.ModuleID = @moduleID
                           AND lp.VehicleID = @vehicleID
                           AND lpd.ShareID = @shareID
                           AND lp.Date <= @date
                 ), 0) + ISNULL(
                 (
                     SELECT-1 * SUM(ShareAmount)
                     FROM tbl_CommitmentTransfer lp
                          JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                          JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.FundShareID
                          JOIN tbl_LimitedPartner t ON lp.FromLPID = t.LimitedPartnerID
                                                       AND lp.FromModuleID = t.ModuleID
                                                       AND t.VehicleID = lp.FundID
                     WHERE lp.FundID = @vehicleID
                           AND vs.VehicleShareID = @ShareID
                           AND lp.Date <= @date
                           --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                           AND lp.FromObjectID = @objectID
                           AND lp.FromModuleID = @moduleID
                 ), 0) + ISNULL(
                 (
                     SELECT SUM(ShareAmount)
                     FROM tbl_CommitmentTransfer lp
                          JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                          JOIN tbl_vehicleShare vs ON vs.VehicleShareID = lpd.ToShareID
                          LEFT JOIN tbl_LimitedPartner t ON lp.ToLPID = t.LimitedPartnerID
                                                            AND lp.ToModuleID = t.ModuleID
                                                            AND t.VehicleID = lp.FundID
                     WHERE lp.FundID = @VehicleID
                           AND vs.VehicleShareID = ISNULL(@shareID, vs.VehicleShareID)
                           AND lp.Date <= @date
                           --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                           AND lp.ToObjectID = @objectID
                           AND lp.ToModuleID = @moduleID
                 ), 0);
         END;
         RETURN ROUND(CAST(@return_value - ISNULL(@amount, 0) AS DECIMAL(18, 3)), 2);
     END;
