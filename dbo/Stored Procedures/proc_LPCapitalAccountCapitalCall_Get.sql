
-- [proc_LPCapitalAccountCapitalCall_Get] 98

CREATE PROCEDURE [dbo].[proc_LPCapitalAccountCapitalCall_Get] @LPID   INT, 
                                                              @FundID INT = NULL
AS
    BEGIN
        SELECT CAST(SUM(ISNULL(cc.Amount, 0)) AS DECIMAL(18, 2)) AS Amount, 
               ccal.DueDate AS CallDate, 
        (
            SELECT veh.Name
            FROM tbl_Vehicle veh
            WHERE veh.VehicleID = ccal.FundID
        ) AS FundName, 
               ccal.CallName, 
               ccal.CallNameFr, 
               ccal.Notes, 
               ccal.NotesFr
        FROM tbl_CapitalCallLimitedPartner cc
             JOIN tbl_capitalcall ccal ON cc.CapitalCallID = ccal.CapitalCallID
             JOIN tbl_LimitedPartner ccal2 ON cc.LimitedPartnerID = ccal2.LimitedPartnerID
        WHERE ccal2.ObjectID = @LPID
              AND ccal.FundID = ISNULL(@FundID, ccal.FundID)
        GROUP BY ccal.FundID, 
                 ccal.DueDate, 
                 ccal.Notes, 
                 ccal.NotesFr, 
                 ccal.CallName, 
                 ccal.CallNameFr
        ORDER BY ccal.DueDate DESC;
    END;
