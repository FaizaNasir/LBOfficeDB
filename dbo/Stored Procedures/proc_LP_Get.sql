CREATE PROC [dbo].[proc_LP_Get]
(@LPID      INT, 
 @vehicleID INT, 
 @objectID  INT, 
 @moduleID  INT
)
AS
    BEGIN
        IF @vehicleID = 0
            SET @vehicleID = NULL;
        SELECT lp.LimitedPartnerID, 
               lp.ModuleID, 
               lp.ObjectID, 
               dbo.F_GetObjectName(lp.ModuleID, lp.ObjectID) ObjectName, 
               lp.VehicleID, 
               lp.Date, 
               lp.Subscription, 
               12 Owned, 
        (
            SELECT SUM(Amount)
            FROM tbl_LimitedPartnerDetail lpd
            WHERE lpd.LimitedPartnerID = lp.LimitedPartnerID
        ) TotalAmount, 
               lp.Notes, 
               lp.Active, 
               lp.CreatedDateTime, 
               lp.ModifiedDateTime, 
               lp.CreatedBy, 
               lp.ModifiedBy
        FROM tbl_LimitedPartner lp
        WHERE LimitedPartnerID = ISNULL(@LPID, LimitedPartnerID)
              AND ObjectID = ISNULL(@objectID, ObjectID)
              AND ModuleID = ISNULL(@moduleID, ModuleID)
              AND lp.VehicleID = ISNULL(@vehicleID, VehicleID)
        ORDER BY ObjectName;
    END;
