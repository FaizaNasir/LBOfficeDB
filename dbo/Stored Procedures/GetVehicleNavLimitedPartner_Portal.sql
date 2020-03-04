CREATE PROC [dbo].[GetVehicleNavLimitedPartner_Portal]
(@date      DATETIME, 
 @moduleID  INT, 
 @objectID  INT, 
 @vehicleID INT, 
 @shareID   INT
)
AS
    BEGIN
        SELECT CAST(
        (
            SELECT SUM(amount)
            FROM tbl_VehicleNavLimitedPartner b
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = b.LimitedPartnerID
            WHERE a.VehicleNavID = b.VehicleNavID
                  AND lp.ObjectID = @objectID
                  AND lp.ModuleID = @moduleID
                  AND b.ShareID = ISNULL(@shareID, b.ShareID)
        )

        -- + ISNULL((select sum(amount) from tbl_CapitalCallLimitedPartner clp
        --join tbl_CapitalCall c on c.CapitalCallID = clp.CapitalCallID
        --join tbl_LimitedPartner lp on clp.LimitedPartnerID = lp.LimitedPartnerID
        --where lp.ModuleID = @moduleID and lp.ObjectID = @objectID
        --and c.CallDate between dbo.F_GetSemesterDate(a.navdate) and a.navdate),0)
        --- ISNULL((select sum(amount) from tbl_distributionLimitedPartner clp
        --join tbl_distribution c on c.distributionID = clp.distributionID
        --join tbl_LimitedPartner lp on clp.LimitedPartnerID = lp.LimitedPartnerID
        --where lp.ModuleID = @moduleID and lp.ObjectID = @objectID
        --and c.Date between dbo.F_GetSemesterDate(a.navdate) and a.navdate),0)

        AS DECIMAL(18, 5)) Amount, 
               a.VehicleNavID, 
               a.NavDate, 
               a.VehicleID
        FROM tbl_VehicleNav a
        WHERE NavDate <= ISNULL(@date, NavDate)
              AND vehicleid = @vehicleID
        ORDER BY NavDate;
    END;
