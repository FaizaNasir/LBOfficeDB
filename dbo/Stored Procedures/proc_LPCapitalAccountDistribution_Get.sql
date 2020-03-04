CREATE PROCEDURE [dbo].[proc_LPCapitalAccountDistribution_Get] @LPID   INT, 
                                                               @FundID INT = NULL
AS
    BEGIN
(
    SELECT CAST(SUM(ISNULL(cc.Amount, 0)) AS DECIMAL(18, 2)) AS Amount, 
           ccal.Date AS CallDate, 
    (
        SELECT veh.Name
        FROM tbl_Vehicle veh
        WHERE veh.VehicleID = ccal.FundID
    ) AS FundName, 
           ccal.Name, 
           ccal.NameFr, 
           ccal.Notes, 
           ccal.NotesFr, 
           'Distribution' Type
    FROM tbl_DistributionLimitedPartner cc
         JOIN tbl_Distribution ccal ON cc.DistributionID = ccal.DistributionID
         JOIN tbl_LimitedPartner ccal2 ON cc.LimitedPartnerID = ccal2.LimitedPartnerID
    WHERE ccal2.ObjectID = @LPID
          AND ccal.FundID = ISNULL(@FundID, ccal.FundID)
    GROUP BY ccal.FundID, 
             ccal.Date, 
             ccal.Name, 
             ccal.NameFr, 
             ccal.Notes, 
             ccal.NotesFr
    UNION
    SELECT CAST(CAST(SUM(aaa.Amount) AS DECIMAL(18, 2)) AS VARCHAR(50)), 
           NavDate AS CallDate, 
    (
        SELECT veh.Name
        FROM tbl_Vehicle veh
        WHERE veh.VehicleID = @FundID
    ) AS FundName, 
           '', 
           '', 
           'Last NAV' Notes, 
           '', 
           'Last NAV' Type
    FROM tbl_VehicleNavLimitedPartner aaa
         JOIN tbl_VehicleNav ccal ON aaa.VehicleNavID = ccal.VehicleNavID
         JOIN tbl_LimitedPartner ccal2 ON aaa.LimitedPartnerID = ccal2.LimitedPartnerID
    WHERE ccal.VehicleID = @FundID
          AND ccal2.ObjectID = @LPID
          AND NavDate =
    (
        SELECT MAX(NavDate)
        FROM tbl_VehicleNav ccal
             JOIN tbl_LimitedPartner ccal2 ON aaa.LimitedPartnerID = ccal2.LimitedPartnerID
        WHERE ccal.VehicleID = @FundID
              AND ccal2.ObjectID = @LPID
    )
    GROUP BY NavDate
)
    ORDER BY Type ASC, 
             CallDate DESC;
    END;
