-- GetPortalChart2 455,5,1089

CREATE PROC [dbo].[GetPortalChart2]
(@objectID  INT, 
 @moduleID  INT, 
 @vehicleID INT
)
AS
    BEGIN
        DECLARE @current INT;
        DECLARE @count INT;
        DECLARE @date DATETIME;
        DECLARE @tbl TABLE
        (ID     INT IDENTITY(1, 1), 
         Date   DATETIME, 
         Amount DECIMAL(18, 2), 
         Type   VARCHAR(100)
        );
        INSERT INTO @tbl
               SELECT NavDate, 
                      amount, 
                      'NAV'
               FROM tbl_vehicleNAV a
                    JOIN tbl_VehicleNavLimitedPartner b ON b.VehicleNavID = a.VehicleNavID
                    JOIN tbl_LimitedPartner lp ON b.limitedpartnerid = lp.limitedpartnerid
               WHERE lp.ModuleID = @moduleID
                     AND lp.ObjectID = @objectID
                     AND a.vehicleID = @vehicleID
               ORDER BY navDate;
        INSERT INTO @tbl
               SELECT callDate, 
                      amount, 
                      'Calls'
               FROM tbl_CapitalCallLimitedPartner a
                    JOIN tbl_capitalcall b ON a.capitalcallid = b.capitalcallid
                    JOIN tbl_LimitedPartner lp ON a.limitedpartnerid = lp.limitedpartnerid
               WHERE lp.ModuleID = @moduleID
                     AND lp.ObjectID = @objectID
                     AND b.fundid = @vehicleID
               ORDER BY callDate;
        INSERT INTO @tbl
               SELECT b.Date, 
                      amount, 
                      'Distributions'
               FROM tbl_DistributionLimitedPartner a
                    JOIN tbl_distribution b ON a.DistributionID = b.DistributionID
                    JOIN tbl_LimitedPartner lp ON a.limitedpartnerid = lp.limitedpartnerid
               WHERE lp.ModuleID = @moduleID
                     AND lp.ObjectID = @objectID
                     AND b.fundid = @vehicleID
               ORDER BY b.Date;
        SELECT *
        FROM @tbl
        WHERE amount <> 0
        ORDER BY Date;
    END;
