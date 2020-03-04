CREATE PROC [dbo].[GetAdjustedNAVBySemester]
(@vehicleID INT, 
 @objectID  INT, 
 @moduleID  INT, 
 @date      DATETIME, 
 @prevDate  DATETIME
)
AS
    BEGIN
        DECLARE @nav DECIMAL(18, 5);
        DECLARE @calls DECIMAL(18, 5);
        DECLARE @distributions DECIMAL(18, 5);
        SET @prevDate =
        (
            SELECT TOP 1 NavDate
            FROM tbl_VehicleNav vn
                 JOIN tbl_VehicleNavLimitedPartner vlp
                 JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = vlp.LimitedPartnerID ON vn.VehicleNavID = vlp.VehicleNavID
            WHERE vn.VehicleID = @vehicleID
                  AND lp.ObjectID = @objectID
                  AND lp.ModuleID = @moduleID
                  AND vn.NavDate <= @date
            ORDER BY vn.NavDate DESC
        );
        SET @nav = ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_vehiclenavLimitedPartner clp
                 JOIN tbl_vehiclenav c ON c.vehiclenavID = clp.vehiclenavID
                 JOIN tbl_LimitedPartner lp ON clp.LimitedPartnerID = lp.LimitedPartnerID
            WHERE lp.ModuleID = @moduleID
                  AND lp.ObjectID = @objectID
                  AND c.VehicleID = @vehicleID
                  AND c.NAVDate = @prevDate
        ), 0);
        SET @calls = ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_CapitalCallLimitedPartner clp
                 JOIN tbl_CapitalCall c ON c.CapitalCallID = clp.CapitalCallID
                 JOIN tbl_LimitedPartner lp ON clp.LimitedPartnerID = lp.LimitedPartnerID
            WHERE lp.ModuleID = @moduleID
                  AND lp.ObjectID = @objectID
                  AND c.FundID = @vehicleID
                  AND c.CallDate BETWEEN ISNULL(@prevDate, c.CallDate) AND @date
        ), 0);
        SET @distributions = ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_DistributionLimitedPartner clp
                 JOIN tbl_Distribution c ON c.DistributionID = clp.DistributionID
                 JOIN tbl_LimitedPartner lp ON clp.LimitedPartnerID = lp.LimitedPartnerID
            WHERE lp.ModuleID = @moduleID
                  AND lp.ObjectID = @objectID
                  AND c.FundID = @vehicleID
                  AND c.Date BETWEEN ISNULL(@prevDate, c.Date) AND @date
        ), 0);
        SELECT @calls Call, 
               @distributions Distributions, 
               @nav NAV, 
               @nav + @calls - @distributions AdjustedNAV;
    END;
