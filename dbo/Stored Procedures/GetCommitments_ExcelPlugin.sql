CREATE PROC [dbo].[GetCommitments_ExcelPlugin]
AS
    BEGIN
        SELECT lp.LimitedPartnerID, 
               lp.Date, 
               v.Name VehicleName, 
               dbo.F_GetObjectModuleName(lp.objectid, lp.moduleid) ObjectName,
               CASE
                   WHEN lp.ModuleID = 4
                   THEN 'Contact'
                   WHEN lp.ModuleID = 5
                   THEN 'Company'
                   WHEN lp.ModuleID = 3
                   THEN 'Fund'
               END LpType, 
               vs.ShareName, 
               lpd.Amount, 
               lp.Subscription, 
               lp.Notes
        FROM tbl_LimitedPartner lp
             LEFT JOIN tbl_LimitedPartnerDetail lpd ON lp.LimitedPartnerID = lpd.LimitedPartnerID
             LEFT JOIN tbl_vehicleshare vs ON vs.VehicleShareID = lpd.ShareID
             LEFT JOIN tbl_vehicle v ON v.VehicleID = lp.VehicleID
        WHERE lpd.Amount IS NOT NULL
        ORDER BY v.Name;
    END;
