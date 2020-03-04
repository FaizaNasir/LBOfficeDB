CREATE PROC [dbo].[GetFundQuarterlyReportMovements]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        DECLARE @tblShare TABLE(ShareID INT);
        DECLARE @tblCalls TABLE
        (Date   DATETIME, 
         Name   VARCHAR(1000), 
         NameFr VARCHAR(1000), 
         Amount DECIMAL(18, 2)
        );
        DECLARE @tblDist TABLE
        (Date   DATETIME, 
         Name   VARCHAR(1000), 
         NameFr VARCHAR(1000), 
         Amount DECIMAL(18, 2)
        );
        INSERT INTO @tblShare
               SELECT VehicleShareID
               FROM tbl_vehicleshare
               WHERE IncludedReport = 1
                     AND VehicleID = @vehicleID;
        INSERT INTO @tblCalls
               SELECT cc.DueDate, 
                      cc.CallName, 
                      cc.CallNameFr, 
               (
                   SELECT SUM(amount)
                   FROM tbl_CapitalCallLimitedPartner ccd
                   WHERE cc.CapitalCallID = ccd.CapitalCallID
                         AND ccd.ShareID IN
                   (
                       SELECT *
                       FROM @tblShare
                   )
               ) Amount
               FROM tbl_CapitalCall cc
               WHERE cc.FundID = @vehicleID
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
                             END;
        INSERT INTO @tblDist
               SELECT cc.Date, 
                      cc.Name, 
                      cc.NameFr, 
               (
                   SELECT SUM(amount)
                   FROM tbl_DistributionLimitedPartner ccd
                   WHERE cc.DistributionID = ccd.DistributionID
                         AND ccd.ShareID IN
                   (
                       SELECT *
                       FROM @tblShare
                   )
               ) Amount
               FROM tbl_Distribution cc
               WHERE cc.FundID = @vehicleID
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
                             END;
        SELECT t.*, 
               ISNULL(CallAmount, 0) - ISNULL(DistAmount, 0) Total, 
               CAST((100 * ISNULL(CallAmount, 0) - ISNULL(DistAmount, 0)) / CASE
                                                                                WHEN
        (
            SELECT SUM(amount)
            FROM tbl_LimitedPartner lp
                 JOIN tbl_LimitedPartnerDetail lpd ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                                      AND lpd.ShareID IN(SELECT *
                                                                         FROM @tblShare)
        ) <> 0
                                                                                THEN
        (
            SELECT SUM(amount)
            FROM tbl_LimitedPartner lp
                 JOIN tbl_LimitedPartnerDetail lpd ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                                      AND lpd.ShareID IN(SELECT *
                                                                         FROM @tblShare)
        )
                                                                                ELSE NULL
                                                                            END AS DECIMAL(18, 2)) Per
        FROM
        (
            SELECT Date, 
                   Name, 
                   NameFr, 
                   Amount CallAmount, 
                   NULL DistAmount
            FROM @tblCalls
            UNION ALL
            SELECT Date, 
                   Name, 
                   NameFr, 
                   NULL, 
                   Amount
            FROM @tblDist
        ) t
        ORDER BY date;
    END;
