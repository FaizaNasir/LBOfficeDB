
-- [[proc_FundOperationCapitalCall_Get]] 78

CREATE PROCEDURE [dbo].[proc_FundOperationCapitalCall_Get] @VehicleID INT
AS
    BEGIN
        SELECT cc.LimitedPartnerID, 
               CAST(SUM(ISNULL(cc.Amount, 0)) AS DECIMAL(18, 2)) AS Amount, 
               ccal.DueDate AS CallDate, 
        (
            SELECT(CASE
                       WHEN lp.ModuleID = 4
                       THEN
            (
                SELECT TOP 1 CI.IndividualFullName
                FROM [tbl_ContactIndividual] CI
                WHERE CI.IndividualID = lp.ObjectID
            )
                       WHEN lp.ModuleID = 5
                       THEN
            (
                SELECT TOP 1 CC.CompanyName
                FROM [tbl_CompanyContact] CC
                WHERE CC.CompanyContactID = lp.ObjectID
            )
                   END)
            FROM tbl_LimitedPartner lp
            WHERE lp.LimitedPartnerID = cc.LimitedPartnerID
        ) AS LimitedPartnerName, 
               ccal.Notes
        FROM tbl_CapitalCallLimitedPartner cc
             JOIN tbl_capitalcall ccal ON cc.CapitalCallID = ccal.CapitalCallID
        WHERE ccal.FundID = @VehicleID
        GROUP BY cc.LimitedPartnerID, 
                 ccal.DueDate, 
                 ccal.Notes
        ORDER BY ccal.DueDate DESC;
    END;
