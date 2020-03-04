CREATE PROC [dbo].[GetFundReportNavGrid]
(@vehicleid INT, 
 @date      DATETIME
)
AS
    BEGIN
        SELECT vs.ShareName, 
               vs.ShareNameFR, 
               CAST(
        (
            SELECT SUM(ISNULL(amount, 0))
            FROM tbl_LimitedPartner lp
                 JOIN tbl_LimitedPartnerDetail lpd ON lp.LimitedPartnerID = lpd.LimitedPartnerID
            WHERE lpd.shareid = vs.VehicleShareID
                  AND lp.Date < @date
                  AND lp.vehicleid = @vehicleID
        ) / NominalValue AS DECIMAL(18, 0)) ShareNumber, 
               NominalValue ShareCalled, 
               0 UnitAmountsDistributed, 
        (
            SELECT TOP 1 NavPerShare
            FROM tbl_VehicleNav n
                 JOIN tbl_VehicleNavDetails nd ON n.VehicleNavID = nd.VehicleNavID
            WHERE n.VehicleID = @vehicleid
                  AND nd.ShareID = vs.VehicleShareID
                  AND n.NavDate <= @date
            ORDER BY n.NavDate DESC
        ) NetAssetValue1, 
        (
            SELECT SUM(ISNULL(amount, 0))
            FROM tbl_CapitalCall c
                 JOIN tbl_CapitalCallLimitedPartner lpc ON c.CapitalCallID = lpc.CapitalCallID
            WHERE c.FundID = @vehicleid
                  AND c.CallDate <= @date
                  AND lpc.ShareID = vs.VehicleShareID
        ) Called, 
        (
            SELECT SUM(ISNULL(amount, 0))
            FROM tbl_Distribution c
                 JOIN tbl_DistributionLimitedPartner lpc ON c.DistributionID = lpc.DistributionID
            WHERE c.FundID = @vehicleid
                  AND c.Date <= @date
                  AND lpc.ShareID = vs.VehicleShareID
        ) TotalAmountsDistributed, 
        (
            SELECT TOP 1 TotalNav
            FROM tbl_VehicleNav n
                 JOIN tbl_VehicleNavDetails nd ON n.VehicleNavID = nd.VehicleNavID
            WHERE n.VehicleID = @vehicleid
                  AND nd.ShareID = vs.VehicleShareID
                  AND n.NavDate <= @date
            ORDER BY n.NavDate DESC
        ) NetAssetValue2
        FROM tbl_vehicleshare vs
        WHERE vs.VehicleID = @vehicleid
              AND vs.IncludedReport = 1;
    END;
