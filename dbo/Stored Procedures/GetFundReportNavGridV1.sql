CREATE PROC [dbo].[GetFundReportNavGridV1]
(@vehicleid INT, 
 @date      DATETIME
)
AS
    BEGIN
        SELECT vs.VehicleShareID, 
               vs.ShareName, 
               vs.ShareNameFR, 
               CAST(
        (
            SELECT SUM(ISNULL(amount, 0))
            FROM tbl_LimitedPartner lp
                 JOIN tbl_LimitedPartnerDetail lpd ON lp.LimitedPartnerID = lpd.LimitedPartnerID
            WHERE lpd.shareid = vs.VehicleShareID
                  AND lp.Date <= @date
                  AND lp.vehicleid = @vehicleID
        ) / ISNULL(
        (
            SELECT TOP 1 vsd.NominalValue
            FROM tbl_VehicleShareDetail vsd
            WHERE vsd.ShareID = vs.VehicleShareID
                  AND vsd.ShareDate <= @date
            ORDER BY vsd.ShareDate DESC
        ), 1) AS DECIMAL(18, 0)) ShareNumber, 
        (
            SELECT TOP 1 NavPerShare
            FROM tbl_VehicleNav n
                 JOIN tbl_VehicleNavDetails nd ON n.VehicleNavID = nd.VehicleNavID
            WHERE n.VehicleID = @vehicleid
                  AND nd.ShareID = vs.VehicleShareID
                  AND 1 = CASE
                              WHEN n.TotalValidationReq = 0
                              THEN 1
                              WHEN n.TotalValidationReq = 1
                                   AND n.IsApproved1 = 1
                              THEN 1
                              WHEN n.TotalValidationReq = 2
                                   AND n.IsApproved2 = 1
                              THEN 1
                              ELSE 0
                          END
                  AND n.NavDate <= @date
            ORDER BY n.NavDate DESC
        ) NetAssetValue1, 
        (
            SELECT SUM(ISNULL(amount, 0))
            FROM tbl_CapitalCall c
                 JOIN tbl_CapitalCallLimitedPartner lpc ON c.CapitalCallID = lpc.CapitalCallID
            WHERE c.FundID = @vehicleid
                  AND c.CallDate <= @date
                  AND 1 = CASE
                              WHEN c.TotalValidationReq = 0
                              THEN 1
                              WHEN c.TotalValidationReq = 1
                                   AND c.IsApproved1 = 1
                              THEN 1
                              WHEN c.TotalValidationReq = 2
                                   AND c.IsApproved2 = 1
                              THEN 1
                              ELSE 0
                          END
                  AND lpc.ShareID = vs.VehicleShareID
        ) Called, 
        (
            SELECT SUM(ISNULL(amount, 0))
            FROM tbl_Distribution c
                 JOIN tbl_DistributionLimitedPartner lpc ON c.DistributionID = lpc.DistributionID
            WHERE c.FundID = @vehicleid
                  AND c.Date <= @date
                  AND 1 = CASE
                              WHEN c.TotalValidationReq = 0
                              THEN 1
                              WHEN c.TotalValidationReq = 1
                                   AND c.IsApproved1 = 1
                              THEN 1
                              WHEN c.TotalValidationReq = 2
                                   AND c.IsApproved2 = 1
                              THEN 1
                              ELSE 0
                          END
                  AND lpc.ShareID = vs.VehicleShareID
        ) TotalAmountsDistributed, 
        (
            SELECT TOP 1 TotalNav
            FROM tbl_VehicleNav n
                 JOIN tbl_VehicleNavDetails nd ON n.VehicleNavID = nd.VehicleNavID
            WHERE n.VehicleID = @vehicleid
                  AND nd.ShareID = vs.VehicleShareID
                  AND n.NavDate <= @date
                  AND 1 = CASE
                              WHEN n.TotalValidationReq = 0
                              THEN 1
                              WHEN n.TotalValidationReq = 1
                                   AND n.IsApproved1 = 1
                              THEN 1
                              WHEN n.TotalValidationReq = 2
                                   AND n.IsApproved2 = 1
                              THEN 1
                              ELSE 0
                          END
            ORDER BY n.NavDate DESC
        ) NetAssetValue2, 
               ISNULL(
        (
            SELECT TOP 1 vsd.NominalValue
            FROM tbl_VehicleShareDetail vsd
            WHERE vsd.ShareID = vs.VehicleShareID
                  AND vsd.ShareDate <= @date
            ORDER BY vsd.ShareDate DESC
        ), 1) ShareCalled, 
               0 UnitAmountsDistributed
        FROM tbl_vehicleshare vs
        WHERE vs.VehicleID = @vehicleid
              AND vs.IncludedReport = 1;
    END;
