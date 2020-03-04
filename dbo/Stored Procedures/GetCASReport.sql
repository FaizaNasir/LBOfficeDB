CREATE PROCEDURE [dbo].[GetCASReport]
(@vehicleNAVID INT, 
 @vehicleID    INT, 
 @startDate    DATETIME, 
 @endtDate     DATETIME, 
 @objectID     INT, 
 @moduleID     INT, 
 @shareid      INT
)
AS
    BEGIN
        DECLARE @lastNAVLP DECIMAL(18, 6);
        DECLARE @initialCommitmentsFund DECIMAL(18, 6);
        DECLARE @initialCommitmentsShare DECIMAL(18, 6);
        DECLARE @initialCommitmentsLP DECIMAL(18, 6);
        DECLARE @calls DECIMAL(18, 6);
        DECLARE @dist DECIMAL(18, 6);
        DECLARE @vehicleNAV DECIMAL(18, 6);
        DECLARE @vehicleSHARENAV DECIMAL(18, 6);
        DECLARE @vehicleSHARENAVLP DECIMAL(18, 6);
        DECLARE @vehicleNAV1 DECIMAL(18, 6);
        DECLARE @vehicleSHARENAV1 DECIMAL(18, 6);
        DECLARE @vehicleSHARENAVLP1 DECIMAL(18, 6);
        DECLARE @vehicleNAV2 DECIMAL(18, 6);
        DECLARE @vehicleSHARENAV2 DECIMAL(18, 6);
        DECLARE @vehicleSHARENAVLP2 DECIMAL(18, 6);
        DECLARE @CapitalContributionsFund1 DECIMAL(18, 6);
        DECLARE @CapitalContributionsFundShare1 DECIMAL(18, 6);
        DECLARE @CapitalContributionsFundShareLP1 DECIMAL(18, 6);
        DECLARE @DistributionContributionsFund DECIMAL(18, 6);
        DECLARE @DistributionContributionsFundShare DECIMAL(18, 6);
        DECLARE @DistributionContributionsFundShareLP DECIMAL(18, 6);
        DECLARE @capitalReimbursementFund1 DECIMAL(18, 6);
        DECLARE @capitalReimbursementFund2 DECIMAL(18, 6);
        DECLARE @capitalReimbursementShares1 DECIMAL(18, 6);
        DECLARE @capitalReimbursementShares2 DECIMAL(18, 6);
        DECLARE @capitalReimbursementFundsexcess1 DECIMAL(18, 6);
        DECLARE @capitalReimbursementSharesexcess1 DECIMAL(18, 6);
        DECLARE @capitalReimbursementFundsexcess2 DECIMAL(18, 6);
        DECLARE @capitalReimbursementSharesexcess2 DECIMAL(18, 6);
        DECLARE @CapitalReimbursementLP2 DECIMAL(18, 6);
        DECLARE @CapitalReimbursementLPexcess2 DECIMAL(18, 6);
        DECLARE @NumberofShares NUMERIC(25, 15);
        DECLARE @nominalVal NUMERIC(25, 15);
        DECLARE @NumberofSharesLP NUMERIC(25, 15);
        DECLARE @TotalCommitmentsFund DECIMAL(18, 6);
        DECLARE @TotalCommitmentsShare DECIMAL(18, 6);
        DECLARE @TotalCommitmentsInvestor DECIMAL(18, 6);
        DECLARE @TotalUndrawnFund DECIMAL(18, 6);
        DECLARE @TotalUndrawnShare DECIMAL(18, 6);
        DECLARE @CapitalContributionsFund2 DECIMAL(18, 6);
        DECLARE @CapitalContributionsFundShare2 DECIMAL(18, 6);
        DECLARE @CapitalContributionsFundShareLP2 DECIMAL(18, 6);
        DECLARE @PayablesAndReceivables DECIMAL(18, 6);
        DECLARE @Liquidities DECIMAL(18, 6);
        DECLARE @Other DECIMAL(18, 6);
        DECLARE @audited BIT;
        DECLARE @initialCommitmentDate DATETIME;
        DECLARE @initialTransferCommitmentDate DATETIME;
        DECLARE @initialTransferCommitment BIT;
        SET @initialCommitmentsFund =
        (
            SELECT SUM(amount)
            FROM tbl_LimitedPartnerDetail
            WHERE limitedpartnerid IN
            (
                SELECT limitedpartnerid
                FROM tbl_LimitedPartner lp
                WHERE lp.VehicleID = @vehicleID
                      AND lp.Date =
                (
                    SELECT TOP 1 lp.Date
                    FROM tbl_LimitedPartnerDetail lpd
                         JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                                       AND lp.VehicleID = @vehicleID
                    ORDER BY lp.Date ASC
                )
            )
        );
        SET @initialCommitmentDate =
        (
            SELECT TOP 1 lp.Date
            FROM tbl_LimitedPartnerDetail lpd
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                               AND lpd.ShareID = @shareid
                                               AND lp.VehicleID = @vehicleID
            ORDER BY lp.Date ASC
        );
        SET @initialTransferCommitmentDate =
        (
            SELECT TOP 1 lp.Date
            FROM tbl_CommitmentTransferFundShare lpd
                 JOIN tbl_CommitmentTransfer lp ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                                   AND lpd.ToShareID = @shareid
                                                   AND lp.FundID = @vehicleID
            ORDER BY lp.Date ASC
        );
        IF(@initialCommitmentDate <= ISNULL(@initialTransferCommitmentDate, @initialCommitmentDate))
            BEGIN
                SET @initialCommitmentsShare =
                (
                    SELECT SUM(amount)
                    FROM tbl_LimitedPartnerDetail lpd
                    WHERE limitedpartnerid IN
                    (
                        SELECT limitedpartnerid
                        FROM tbl_LimitedPartner lp
                        WHERE lp.VehicleID = @vehicleID
                              AND lp.Date = @initialCommitmentDate
                    )
                          AND lpd.ShareID = @shareid
                );
        END;
            ELSE
            IF(@initialCommitmentDate > @initialTransferCommitmentDate)
                BEGIN
                    SET @initialCommitmentsShare =
                    (
                        SELECT SUM(ShareAmount)
                        FROM tbl_CommitmentTransferFundShare lpd
                             JOIN tbl_CommitmentTransfer lp ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                                               AND lp.FundID = @vehicleID
                                                               AND lpd.ToShareID = @shareid
                                                               AND lp.Date = @initialTransferCommitmentDate
                    );
            END;
        SET @initialCommitmentDate =
        (
            SELECT TOP 1 lp.Date
            FROM tbl_LimitedPartnerDetail lpd
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                               AND lp.ObjectID = @objectID
                                               AND lpd.ShareID = @shareid
                                               AND lp.ModuleID = @moduleID
                                               AND lp.VehicleID = @vehicleID
            ORDER BY lp.Date ASC
        );
        SET @initialTransferCommitmentDate =
        (
            SELECT TOP 1 lp.Date
            FROM tbl_CommitmentTransferFundShare lpd
                 JOIN tbl_CommitmentTransfer lp ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                                   AND lp.ToObjectID = @objectID
                                                   AND lpd.ToShareID = @shareid
                                                   AND lp.ToModuleID = @moduleID
                                                   AND lp.FundID = @vehicleID
            ORDER BY lp.Date ASC
        );
        IF(@initialCommitmentDate <= ISNULL(@initialTransferCommitmentDate, @initialCommitmentDate))
            BEGIN
                SET @initialCommitmentsLP =
                (
                    SELECT SUM(amount)
                    FROM tbl_LimitedPartnerDetail lpd
                         JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                    WHERE lp.limitedpartnerid IN
                    (
                        SELECT limitedpartnerid
                        FROM tbl_LimitedPartner lp
                        WHERE lp.VehicleID = @vehicleID
                              AND lp.Date = @initialCommitmentDate
                    )
                          AND ShareID = @shareid
                          AND ModuleID = @moduleID
                          AND ObjectID = @objectID
                );
        END;
            ELSE
            IF(@initialCommitmentDate > @initialTransferCommitmentDate)
                BEGIN
                    SET @initialCommitmentsLP =
                    (
                        SELECT SUM(ShareAmount)
                        FROM tbl_CommitmentTransferFundShare lpd
                             JOIN tbl_CommitmentTransfer lp ON lp.CommitmentTransferID = lpd.CommitmentTransferID
                                                               AND lp.ToObjectID = @objectID
                                                               AND lpd.ToShareID = @shareid
                                                               AND lp.ToModuleID = @moduleID
                                                               AND lp.FundID = @vehicleID
                                                               AND lp.Date = @initialTransferCommitmentDate
                    );
            END;
        SET @nominalVal =
        (
            SELECT TOP 1 a.NominalValue
            FROM tbl_VehicleshareDetail a
            WHERE a.ShareID = @ShareID
                  AND a.ShareDate <= @endtDate
            ORDER BY a.ShareDate DESC
        );
        SET @NumberofShares =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_LimitedPartnerDetail vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
            WHERE lp.VehicleID = @vehicleID
                  AND vlp.ShareID = @shareid
                  AND lp.Date <= @endtDate
        ) / @nominalVal;
        SET @NumberofSharesLP = (ISNULL(
        (
            SELECT SUM(vlp.amount)
            FROM tbl_LimitedPartnerDetail vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
            WHERE lp.VehicleID = @vehicleID
                  AND vlp.ShareID = @shareid
                  AND lp.Date <= @endtDate
                  --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                  AND lp.ObjectID = @objectID
                  AND lp.ModuleID = @moduleID
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
                  AND lp.Date <= @endtDate
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
                  AND lp.Date <= @endtDate
                  --AND lp.Date >= DATEADD(Month, -6, @endtDate)
                  AND lp.ToObjectID = @objectID
                  AND lp.ToModuleID = @moduleID
        ), 0)) / @nominalVal;
        SET @TotalCommitmentsFund =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_LimitedPartnerDetail vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
            WHERE lp.VehicleID = @vehicleID
                  AND lp.Date <= @endtDate
        );
        SET @TotalCommitmentsShare =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_LimitedPartnerDetail vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
            WHERE lp.VehicleID = @vehicleID
                  AND vlp.ShareID = @shareid
                  AND lp.Date <= @endtDate
        );
        SET @TotalCommitmentsInvestor = ISNULL(
        (
            SELECT SUM(vlp.amount)
            FROM tbl_LimitedPartnerDetail vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
            WHERE lp.VehicleID = @vehicleID
                  AND vlp.ShareID = @shareid
                  AND lp.ObjectID = @objectID
                  AND lp.ModuleID = @moduleID
                  AND lp.Date <= @endtDate
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
                  AND lp.Date <= @endtDate
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
                  AND lp.Date <= @endtDate
                  AND lp.ToObjectID = @objectID
                  AND lp.ToModuleID = @moduleID
        ), 0);
        SET @lastNAVLP =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_VehicleNavLimitedPartner vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
            WHERE VehicleNavID =
            (
                SELECT TOP 1 VehicleNavID
                FROM tbl_VehicleNav n
                WHERE n.VehicleID = @vehicleID
                ORDER BY n.NavDate DESC
            )
                  AND lp.ObjectID = @objectID
                  AND lp.ModuleID = @moduleID
                  AND vlp.ShareID = @shareid
        );
        SET @audited =
        (
            SELECT Audited
            FROM tbl_VehicleNav n
            WHERE n.VehicleNavID = @VehicleNavID
        );
        SET @vehicleSHARENAVLP =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_VehicleNavLimitedPartner vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
            WHERE VehicleNavID =
            (
                SELECT TOP 1 VehicleNavID
                FROM tbl_VehicleNav n
                WHERE n.VehicleID = @vehicleID
                      AND n.NavDate <= @startDate
                ORDER BY n.NavDate DESC
            )
                  AND lp.ObjectID = @objectID
                  AND lp.ModuleID = @moduleID
                  AND vlp.ShareID = @shareid
        );
        SET @vehicleSHARENAVLP1 =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_VehicleNavLimitedPartner vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
            WHERE VehicleNavID =
            (
                SELECT TOP 1 VehicleNavID
                FROM tbl_VehicleNav n
                WHERE n.VehicleID = @vehicleID
                      AND n.NavDate <= CAST(('12/31/' + CAST(YEAR(@endtDate) AS VARCHAR(50))) AS DATETIME)
                ORDER BY n.NavDate DESC
            )
                  AND lp.ObjectID = @objectID
                  AND lp.ModuleID = @moduleID
                  AND vlp.ShareID = @shareid
        );
        SET @vehicleSHARENAVLP2 =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_VehicleNavLimitedPartner vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
            WHERE VehicleNavID =
            (
                SELECT TOP 1 VehicleNavID
                FROM tbl_VehicleNav n
                WHERE n.VehicleID = @vehicleID
                      AND n.NavDate <= @endtDate
                ORDER BY n.NavDate DESC
            )
                  AND lp.ObjectID = @objectID
                  AND lp.ModuleID = @moduleID
                  AND vlp.ShareID = @shareid
        );
        SET @calls =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_CapitalCallLimitedPartner vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
                 JOIN tbl_CapitalCall c ON c.CapitalCallID = vlp.CapitalCallID
                                           AND lp.ObjectID = @objectID
                                           AND lp.ModuleID = @moduleID
                                           AND vlp.ShareID = @shareid
                                           AND c.CallDate <= @endtDate
        );
        SET @dist =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_DistributionLimitedPartner vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
                 JOIN tbl_Distribution c ON c.DistributionID = vlp.DistributionID
                                            AND lp.ObjectID = @objectID
                                            AND lp.ModuleID = @moduleID
                                            AND vlp.ShareID = @shareid
                                            AND c.Date <= @endtDate
        );
        SET @vehicleNAV =
        (
            SELECT TOP 1 ISNULL(PortfolioNAV, 0) + ISNULL(WorkingCapital, 0) + ISNULL(Cash, 0) + ISNULL(Other, 0)
            FROM tbl_VehicleNav n
            WHERE n.VehicleID = @vehicleID
                  AND n.NavDate <= @startDate
            ORDER BY n.NavDate DESC
        );
        SET @vehicleNAV1 =
        (
            SELECT TOP 1 ISNULL(PortfolioNAV, 0) + ISNULL(WorkingCapital, 0) + ISNULL(Cash, 0) + ISNULL(Other, 0)
            FROM tbl_VehicleNav n
            WHERE n.VehicleID = @vehicleID
                  AND n.NavDate <= CAST(('12/31/' + CAST(YEAR(@endtDate) AS VARCHAR(50))) AS DATETIME)
            ORDER BY n.NavDate DESC
        );
        SET @vehicleNAV2 =
        (
            SELECT TOP 1 ISNULL(PortfolioNAV, 0) + ISNULL(WorkingCapital, 0) + ISNULL(Cash, 0) + ISNULL(Other, 0)
            FROM tbl_VehicleNav n
            WHERE n.VehicleID = @vehicleID
                  AND n.NavDate <= @endtDate
            ORDER BY n.NavDate DESC
        );
        SET @vehicleSHARENAV =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_VehicleNavLimitedPartner vlp
            WHERE VehicleNavID =
            (
                SELECT TOP 1 VehicleNavID
                FROM tbl_VehicleNav n
                WHERE n.VehicleID = @vehicleID
                      AND n.NavDate <= @startDate
                ORDER BY n.NavDate DESC
            )
                  AND vlp.ShareID = @shareid
        );
        SET @vehicleSHARENAV1 =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_VehicleNavLimitedPartner vlp
            WHERE VehicleNavID =
            (
                SELECT TOP 1 VehicleNavID
                FROM tbl_VehicleNav n
                WHERE n.VehicleID = @vehicleID
                      AND n.NavDate <= CAST(('12/31/' + CAST(YEAR(@endtDate) AS VARCHAR(50))) AS DATETIME)
                ORDER BY n.NavDate DESC
            )
                  AND vlp.ShareID = @shareid
        );
        SET @vehicleSHARENAV2 =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_VehicleNavLimitedPartner vlp
            WHERE VehicleNavID =
            (
                SELECT TOP 1 VehicleNavID
                FROM tbl_VehicleNav n
                WHERE n.VehicleID = @vehicleID
                      AND n.NavDate <= @endtDate
                ORDER BY n.NavDate DESC
            )
                  AND vlp.ShareID = @shareID
        );
        SET @CapitalContributionsFund1 =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_CapitalCallLimitedPartner vlp
                 JOIN tbl_CapitalCall c ON c.CapitalCallID = vlp.CapitalCallID
                                           AND 1 = CASE
                                                       WHEN MONTH(@endtDate) = 6
                                                            AND c.CallDate >= DATEADD(Day, 2, DATEADD(Month, -6, @endtDate))
                                                       THEN 1
                                                       WHEN MONTH(@endtDate) <> 6
                                                            AND c.CallDate >= DATEADD(Day, 1, DATEADD(Month, -6, @endtDate))
                                                       THEN 1
                                                       ELSE 0
                                                   END
                                           AND c.CallDate <= @endtDate
                                           AND c.fundid = @vehicleID
        );
        SET @CapitalContributionsFundShare1 =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_CapitalCallLimitedPartner vlp
                 JOIN tbl_CapitalCall c ON c.CapitalCallID = vlp.CapitalCallID
                                           AND 1 = CASE
                                                       WHEN MONTH(@endtDate) = 6
                                                            AND c.CallDate >= DATEADD(Day, 2, DATEADD(Month, -6, @endtDate))
                                                       THEN 1
                                                       WHEN MONTH(@endtDate) <> 6
                                                            AND c.CallDate >= DATEADD(Day, 1, DATEADD(Month, -6, @endtDate))
                                                       THEN 1
                                                       ELSE 0
                                                   END
                                           AND c.CallDate <= @endtDate
                                           AND c.fundid = @vehicleID
            WHERE vlp.ShareID = @shareid
        );
        SET @CapitalcontributionsFundShareLP1 =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_CapitalCallLimitedPartner vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
                 JOIN tbl_CapitalCall c ON c.CapitalCallID = vlp.CapitalCallID
                                           AND lp.ObjectID = @objectID
                                           AND lp.ModuleID = @moduleID
                                           AND vlp.ShareID = @shareid
                                           AND 1 = CASE
                                                       WHEN MONTH(@endtDate) = 6
                                                            AND c.CallDate >= DATEADD(Day, 2, DATEADD(Month, -6, @endtDate))
                                                       THEN 1
                                                       WHEN MONTH(@endtDate) <> 6
                                                            AND c.CallDate >= DATEADD(Day, 1, DATEADD(Month, -6, @endtDate))
                                                       THEN 1
                                                       ELSE 0
                                                   END
                                           AND c.CallDate <= @endtDate
                                           AND c.fundid = @vehicleID
        );
        SET @CapitalContributionsFund2 =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_CapitalCallLimitedPartner vlp
                 JOIN tbl_CapitalCall c ON c.CapitalCallID = vlp.CapitalCallID
            WHERE c.FundID = @vehicleID
                  AND c.CallDate <= @endtDate
        );
        SET @CapitalContributionsFundShare2 =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_CapitalCallLimitedPartner vlp
                 JOIN tbl_CapitalCall c ON c.CapitalCallID = vlp.CapitalCallID
            WHERE vlp.ShareID = @shareid
                  AND c.CallDate <= @endtDate
                  AND c.FundID = @vehicleID
        );
        SET @CapitalcontributionsFundShareLP2 =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_CapitalCallLimitedPartner vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
                 JOIN tbl_CapitalCall c ON c.CapitalCallID = vlp.CapitalCallID
                                           AND lp.ObjectID = @objectID
                                           AND lp.ModuleID = @moduleID
                                           AND vlp.ShareID = @shareid
                                           AND c.CallDate <= @endtDate
                                           AND c.FundID = @vehicleID
        );
        SET @DistributionContributionsFund =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_DistributionLimitedPartner vlp
                 JOIN tbl_Distribution c ON c.DistributionID = vlp.DistributionID
            WHERE c.FundID = @vehicleID
                  AND c.Date >= DATEADD(Month, -6, @endtDate)
                  AND c.Date <= @endtDate
        );
        SET @DistributionContributionsFundShare =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_DistributionLimitedPartner vlp
                 JOIN tbl_Distribution c ON c.DistributionID = vlp.DistributionID
                                            AND c.Date >= DATEADD(Month, -6, @endtDate)
                                            AND c.Date <= @endtDate
                                            AND c.FundID = @vehicleID
            WHERE vlp.ShareID = @shareid
        );
        SET @DistributionContributionsFundShareLP =
        (
            SELECT SUM(vlp.amount)
            FROM tbl_DistributionLimitedPartner vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID
                 JOIN tbl_Distribution c ON c.DistributionID = vlp.DistributionID
                                            AND lp.ObjectID = @objectID
                                            AND lp.ModuleID = @moduleID
                                            AND vlp.ShareID = @shareid
                                            AND c.Date >= DATEADD(Month, -6, @endtDate)
                                            AND c.Date <= @endtDate
                                            AND c.FundID = @vehicleID
        );
        SET @TotalUndrawnFund =
        (
            SELECT SUM(vlp.Undrawn)
            FROM tbl_VehicleNavDetails vlp
            WHERE vlp.vehicleNavID = @vehicleNAVID
        );
        SET @TotalUndrawnShare =
        (
            SELECT SUM(vlp.Undrawn)
            FROM tbl_VehicleNavDetails vlp
            WHERE vlp.vehicleNavID = @vehicleNAVID
                  AND vlp.ShareID = @shareid
        );
        SELECT @capitalReimbursementFund1 = SUM(do.ReturnOfCapital), 
               @CapitalReimbursementFundsexcess1 = SUM(do.Profit)
        FROM tbl_distribution d
             JOIN tbl_distributionoperation do ON d.distributionid = do.distributionid
        WHERE d.fundid = @vehicleID
              AND d.date >= DATEADD(Month, -6, @endtDate)
              AND d.date <= @endtDate;
        SELECT @capitalReimbursementFund2 = SUM(do.ReturnOfCapital), 
               @CapitalReimbursementFundsexcess2 = SUM(do.Profit)
        FROM tbl_distribution d
             JOIN tbl_distributionoperation do ON d.distributionid = do.distributionid
        WHERE d.fundid = @vehicleID
              AND d.date <= @endtDate;
        SELECT @capitalReimbursementShares1 = SUM(do.ReturnOfCapital), 
               @capitalReimbursementSharesexcess1 = SUM(do.Profit)
        FROM tbl_distribution d
             JOIN tbl_distributionoperation do ON d.distributionid = do.distributionid
        WHERE d.fundid = @vehicleID
              AND do.ShareID = @shareid
              AND d.date >= DATEADD(Month, -6, @endtDate)
              AND d.date <= @endtDate;
        SELECT @capitalReimbursementShares2 = SUM(do.ReturnOfCapital), 
               @capitalReimbursementSharesexcess2 = SUM(do.Profit)
        FROM tbl_distribution d
             JOIN tbl_distributionoperation do ON d.distributionid = do.distributionid
        WHERE d.fundid = @vehicleID
              AND do.ShareID = @shareid
              AND d.date <= @endtDate;
        SELECT TOP 1 @PayablesAndReceivables = WorkingCapital, 
                     @Liquidities = Cash, 
                     @Other = Other
        FROM tbl_VehicleNav vn
        WHERE vehicleid = @vehicleID
              AND vn.NavDate <= @endtDate
        ORDER BY NavDate DESC;
        SELECT ISNULL(@lastNAVLP, 0) LastNAV, 
               ISNULL(@calls, 0) Calls,
               CASE
                   WHEN ISNULL(@calls, 0) = 0
                   THEN 0
                   ELSE ISNULL(@lastNAVLP / @calls, 0)
               END TotalValueToPaidinCapital,
               CASE
                   WHEN ISNULL(@calls, 0) = 0
                   THEN 0
                   ELSE ISNULL(@dist / @calls, 0)
               END DistributionsToPaidInCapital, 
               ISNULL(@vehicleNAV, 0) VehicleNAV, 
               ISNULL(@vehicleSHARENAV, 0) VehicleShareNAV, 
               ISNULL(@vehicleSHARENAVLP, 0) VehicleShareNAVLP, 
               ISNULL(@vehicleNAV1, 0) VehicleNAV1, 
               ISNULL(@vehicleSHARENAV1, 0) VehicleShareNAV1, 
               ISNULL(@vehicleSHARENAVLP1, 0) VehicleShareNAVLP1, 
               ISNULL(@vehicleNAV2, 0) VehicleNAV2, 
               ISNULL(@vehicleSHARENAV2, 0) VehicleShareNAV2, 
               ISNULL(@vehicleSHARENAVLP2, 0) VehicleShareNAVLP2, 
               ISNULL(@CapitalcontributionsFund1, 0) CapitalcontributionsFund1, 
               ISNULL(@CapitalcontributionsFundShare1, 0) CapitalcontributionsFundShare1, 
               ISNULL(@CapitalcontributionsFundShareLP1, 0) CapitalcontributionsFundShareLP1, 
               ISNULL(@CapitalcontributionsFund2, 0) CapitalcontributionsFund2, 
               ISNULL(@CapitalcontributionsFundShare2, 0) CapitalContributionsFundShare2, 
               ISNULL(@CapitalcontributionsFundShareLP2, 0) CapitalContributionsFundShareLP2, 
               -1 * ISNULL(@DistributionContributionsFund, 0) DistributionContributionsFund, 
               -1 * ISNULL(@DistributionContributionsFundShare, 0) DistributionContributionsFundShare, 
               -1 * ISNULL(@DistributionContributionsFundShareLP, 0) DistributionContributionsFundShareLP, 
               -1 * ISNULL(@capitalReimbursementFund1, 0) CapitalReimbursementFund1, 
               -1 * ISNULL(@capitalReimbursementShares1, 0) CapitalReimbursementShares1, 
               -1 * ISNULL(@capitalReimbursementFundsexcess1, 0) CapitalReimbursementFundsexcess1, 
               -1 * ISNULL(@capitalReimbursementSharesexcess1, 0) CapitalReimbursementSharesexcess1, 
               ISNULL(@NumberofShares, 0) NumberofShares, 
               ISNULL(@NumberofSharesLP, 0) NumberofSharesLP, 
               ISNULL(@TotalCommitmentsFund, 0) TotalCommitmentsFund, 
               ISNULL(@TotalCommitmentsShare, 0) TotalCommitmentsShare, 
               ISNULL(@TotalCommitmentsInvestor, 0) TotalCommitmentsInvestor, 
               ISNULL(@TotalCommitmentsShare / @TotalCommitmentsFund, 0) CommitmentsSharePer, 
               ISNULL(@TotalCommitmentsInvestor / @TotalCommitmentsFund, 0) CommitmentsShareInvestorPer, 
               ISNULL(@TotalUndrawnFund, 0) TotalUndrawnFund, 
               ISNULL(@TotalUndrawnShare, 0) TotalUndrawnShare, 
               -1 * ISNULL(@capitalReimbursementFund2, 0) CapitalReimbursementFund2, 
               -1 * ISNULL(@capitalReimbursementShares2, 0) CapitalReimbursementShares2, 
               -1 * ISNULL(@capitalReimbursementFundsexcess2, 0) CapitalReimbursementFundsexcess2, 
               -1 * ISNULL(@capitalReimbursementSharesexcess2, 0) CapitalReimbursementSharesexcess2, 
               ISNULL(@PayablesAndReceivables, 0) PayablesAndReceivables, 
               ISNULL(@Liquidities, 0) Liquidities, 
               ISNULL(@Other, 0) Other, 
               (ISNULL(@TotalCommitmentsInvestor, 0) / ISNULL(@TotalCommitmentsShare, 0)) * (-1 * ISNULL(@capitalReimbursementSharesexcess2, 0)) CapitalReimbursementLPexcess2, 
               -1 * ISNULL(@CapitalReimbursementLP2, 0) CapitalReimbursementLP2, 
               ISNULL(@audited, 0) Audited, 
               ISNULL(@initialCommitmentsFund, 0) InitialCommitmentsFund, 
               ISNULL(@initialCommitmentsShare, 0) InitialCommitmentsShare, 
               ISNULL(@initialCommitmentsLP, 0) InitialCommitmentsLP;
    END;
