CREATE PROC [dbo].[GetFundQuarterlyReportTotalCommitments]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        SELECT lpd.ShareID, 
               SUM(amount) Amount, 
               0 IsDistribution
        FROM tbl_limitedpartner lp
             JOIN tbl_limitedpartnerDetail lpd ON lp.limitedpartnerid = lpd.limitedpartnerid
             JOIN tbl_vehicleShare vc ON vc.VehicleShareID = lpd.shareID
        WHERE lp.VehicleID = @vehicleID
              AND IncludedReport = 1
              AND lp.date <= @date
        GROUP BY lpd.ShareID
        UNION ALL
        SELECT dp.ShareID, 
               SUM(Recallable) Amount, 
               1 IsDistribution
        FROM tbl_distribution d
             JOIN tbl_DistributionOperation dp ON d.DistributionID = dp.DistributionID
             JOIN tbl_vehicleShare vc ON vc.VehicleShareID = dp.shareID
        WHERE d.FundID = @vehicleID
              AND IncludedReport = 1
              AND d.date <= @date
        GROUP BY dp.ShareID;
    END;
