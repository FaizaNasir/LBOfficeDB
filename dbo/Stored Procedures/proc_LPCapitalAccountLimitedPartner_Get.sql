
-- [proc_LPCapitalAccountLimitedPartner_Get] 5745

CREATE PROCEDURE [dbo].[proc_LPCapitalAccountLimitedPartner_Get] @LPID   INT, 
                                                                 @FundID INT = NULL
AS
    BEGIN
        SELECT CAST(SUM(ISNULL(cc.Amount, 0)) AS DECIMAL(18, 2)) AS Amount, 
               ccal.Date AS CallDate, 
        (
            SELECT veh.Name
            FROM tbl_Vehicle veh
            WHERE veh.VehicleID = ccal.VehicleID
        ) AS FundName, 
               ccal.Notes
        FROM tbl_LimitedPartnerDetail cc
             JOIN tbl_LimitedPartner ccal ON cc.LimitedPartnerID = ccal.LimitedPartnerID
        WHERE ccal.ObjectID = ISNULL(@LPID, ccal.ObjectID)
              AND ccal.VehicleID = ISNULL(@FundID, ccal.VehicleID)
              AND ModuleID IS NOT NULL
              AND ObjectID IS NOT NULL
        GROUP BY ccal.VehicleID, 
                 ModuleID, 
                 ccal.Date, 
                 ccal.Notes
        ORDER BY ccal.Date DESC;
    END;
