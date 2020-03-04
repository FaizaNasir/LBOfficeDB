CREATE PROCEDURE [dbo].[proc_FundPerformance_Get] @FundID  INT      = NULL, 
                                                  @date    DATETIME, 
                                                  @shareID INT
AS
    BEGIN
        IF @date IS NULL
            SET @date = GETDATE();
        SELECT P.Date, 
               P.Amount, 
               P.TypeOfOperation
        FROM
        (
            SELECT ccal.DueDate AS 'Date', 
                   -CAST(SUM(ISNULL(cc.Amount, 0)) AS DECIMAL(18, 2)) AS Amount, 
                   'Capital Call' AS TypeOfOperation
            FROM tbl_CapitalCallLimitedPartner cc
                 JOIN tbl_capitalcall ccal ON cc.CapitalCallID = ccal.CapitalCallID
            WHERE ccal.FundID = ISNULL(@FundID, ccal.FundID)
                  AND cc.ShareID = ISNULL(@shareID, cc.ShareID)
                  AND ccal.DueDate <= @date
                  AND 1 = CASE
                              WHEN TotalValidationReq = 0
                              THEN 1
                              WHEN TotalValidationReq = 1
                                   AND IsApproved1 = 1
                              THEN 1
                              WHEN TotalValidationReq = 2
                                   AND IsApproved1 = 1
                                   AND IsApproved2 = 1
                              THEN 1
                              ELSE 0
                          END
            GROUP BY ccal.DueDate
            UNION
            SELECT ccal.Date AS 'Date', 
                   CAST(SUM(ISNULL(cc.Amount, 0)) AS DECIMAL(18, 2)) AS Amount, 
                   'Distribution' TypeOfOperation
            FROM tbl_DistributionLimitedPartner cc
                 JOIN tbl_Distribution ccal ON cc.DistributionID = ccal.DistributionID
            WHERE ccal.FundID = ISNULL(@FundID, ccal.FundID)
                  AND cc.ShareID = ISNULL(@shareID, cc.ShareID)
                  AND ccal.Date <= @date
                  AND 1 = CASE
                              WHEN TotalValidationReq = 0
                              THEN 1
                              WHEN TotalValidationReq = 1
                                   AND IsApproved1 = 1
                              THEN 1
                              WHEN TotalValidationReq = 2
                                   AND IsApproved1 = 1
                                   AND IsApproved2 = 1
                              THEN 1
                              ELSE 0
                          END
            GROUP BY ccal.Date
            UNION
            SELECT CASE
                       WHEN NavDate <= @date
                       THEN @date
                       ELSE NavDate
                   END AS Date, 
                   CAST(CAST(SUM(ISNULL(ccal.PortfolioNAV, 0) + ISNULL(ccal.WorkingCapital, 0) + ISNULL(ccal.Cash, 0) + ISNULL(ccal.Other, 0) + ISNULL(ccal.Expenses, 0) + ISNULL(ccal.UnrealizedHedging, 0)) AS DECIMAL(18, 2)) AS VARCHAR(50)), 
                   'Last NAV' TypeOfOperation
            FROM tbl_VehicleNav ccal
            WHERE ccal.VehicleID = ISNULL(@FundID, ccal.VehicleID)
                  AND 1 = CASE
                              WHEN TotalValidationReq = 0
                              THEN 1
                              WHEN TotalValidationReq = 1
                                   AND IsApproved1 = 1
                              THEN 1
                              WHEN TotalValidationReq = 2
                                   AND IsApproved1 = 1
                                   AND IsApproved2 = 1
                              THEN 1
                              ELSE 0
                          END
                  AND NavDate =
            (
                SELECT MAX(NavDate)
                FROM tbl_VehicleNav ccal
                WHERE ccal.VehicleID = ISNULL(@FundID, ccal.VehicleID)
                      AND ccal.NavDate <= GETDATE()
                      AND 1 = CASE
                                  WHEN TotalValidationReq = 0
                                  THEN 1
                                  WHEN TotalValidationReq = 1
                                       AND IsApproved1 = 1
                                  THEN 1
                                  WHEN TotalValidationReq = 2
                                       AND IsApproved1 = 1
                                       AND IsApproved2 = 1
                                  THEN 1
                                  ELSE 0
                              END
            )
            GROUP BY NavDate
        ) P
        ORDER BY P.Date DESC;
    END;
