CREATE PROC [dbo].[GetFundQuarterlyReportMovementsV1]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        DECLARE @tblCalls TABLE
        (ID      VARCHAR(100), 
         Date    DATETIME, 
         Name    VARCHAR(1000), 
         NameFr  VARCHAR(1000), 
         ShareID INT, 
         Amount  DECIMAL(18, 2)
        );
        DECLARE @tblDist TABLE
        (ID      VARCHAR(100), 
         Date    DATETIME, 
         Name    VARCHAR(1000), 
         NameFr  VARCHAR(1000), 
         ShareID INT, 
         Amount  DECIMAL(18, 2)
        );
        INSERT INTO @tblCalls
               SELECT cc.capitalcallid, 
                      cc.DueDate, 
                      cc.CallName, 
                      cc.CallNameFr, 
                      ccd.ShareID,
                      CASE
                          WHEN SUM(amount) = 0
                          THEN NULL
                          ELSE SUM(amount)
                      END Amount
               FROM tbl_CapitalCall cc
                    JOIN tbl_CapitalCallLimitedPartner ccd ON cc.CapitalCallID = ccd.CapitalCallID
                    JOIN tbl_vehicleShare vc ON vc.VehicleShareID = ccd.shareID
               WHERE cc.FundID = @vehicleID
                     AND IncludedReport = 1
                     AND cc.CallDate <= @date
                     AND 1 = CASE
                                 WHEN cc.TotalValidationReq = 0
                                 THEN 1
                                 WHEN cc.TotalValidationReq = 1
                                      AND cc.IsApproved1 = 1
                                 THEN 1
                                 WHEN cc.TotalValidationReq = 2
                                      AND cc.IsApproved2 = 1
                                 THEN 1
                                 ELSE 0
                             END
               GROUP BY cc.capitalcallid, 
                        cc.DueDate, 
                        cc.CallName, 
                        cc.CallNameFr, 
                        ccd.ShareID;
        INSERT INTO @tblDist
               SELECT cc.distributionid, 
                      cc.Date, 
                      cc.Name, 
                      cc.NameFr, 
                      ccd.ShareID,
                      CASE
                          WHEN SUM(amount) = 0
                          THEN NULL
                          ELSE SUM(amount)
                      END Amount
               FROM tbl_Distribution cc
                    JOIN tbl_DistributionLimitedPartner ccd ON cc.DistributionID = ccd.DistributionID
                    JOIN tbl_vehicleShare vc ON vc.VehicleShareID = ccd.shareID
               WHERE cc.FundID = @vehicleID
                     AND IncludedReport = 1
                     AND cc.Date <= @date
                     AND 1 = CASE
                                 WHEN cc.TotalValidationReq = 0
                                 THEN 1
                                 WHEN cc.TotalValidationReq = 1
                                      AND cc.IsApproved1 = 1
                                 THEN 1
                                 WHEN cc.TotalValidationReq = 2
                                      AND cc.IsApproved2 = 1
                                 THEN 1
                                 ELSE 0
                             END
               GROUP BY cc.distributionid, 
                        cc.Date, 
                        cc.Name, 
                        cc.NameFr, 
                        ccd.ShareID;
        SELECT t.*
        FROM
        (
            SELECT 'C' + ID ID, 
                   Date, 
                   Name, 
                   NameFr, 
                   ShareID, 
                   Amount, 
                   1 IsCall
            FROM @tblCalls
            UNION ALL
            SELECT 'D' + ID ID, 
                   Date, 
                   Name, 
                   NameFr, 
                   ShareID, 
                   Amount, 
                   0 IsCall
            FROM @tblDist
        ) t
        ORDER BY date;
    END;
