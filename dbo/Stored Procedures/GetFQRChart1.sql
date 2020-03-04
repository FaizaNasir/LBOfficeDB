CREATE PROC GetFQRChart1
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        DECLARE @tbl TABLE
        (ID            INT IDENTITY(1, 1), 
         Calls         DECIMAL(18, 6), 
         Distributions DECIMAL(18, 6), 
         Nav           DECIMAL(18, 6), 
         Date          DATETIME
        );
        DECLARE @Calls DECIMAL(18, 6);
        DECLARE @Distributions DECIMAL(18, 6);
        DECLARE @Nav DECIMAL(18, 6);
        DECLARE @startDate DATETIME;
        SET @startDate =
        (
            SELECT TOP 1 '12-31-' + CAST(YEAR(FirstClosingOn) AS VARCHAR(100))
            FROM tbl_VehicleLegal
            WHERE vehicleid = @vehicleID
        );
        WHILE(YEAR(@startDate) <= YEAR(@date))
            BEGIN        
                --SELECT @startDate;        
                SET @Calls =
                (
                    SELECT SUM(amount)
                    FROM tbl_CapitalCallLimitedPartner clp
                         JOIN tbl_CapitalCall c ON c.CapitalCallID = clp.CapitalCallID
                         JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                                     AND vs.ExportChart = 1
                    WHERE c.FundID = @vehicleID
                          AND c.DueDate <= @startDate
                          AND vs.ShareName IN('A', 'B')
                );
                SET @Distributions =
                (
                    SELECT SUM(amount)
                    FROM tbl_DistributionLimitedPartner clp
                         JOIN tbl_Distribution c ON c.DistributionID = clp.DistributionID
                         JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                                     AND vs.ExportChart = 1
                    WHERE c.FundID = @vehicleID
                          AND c.Date <= @startDate
                          AND vs.ShareName IN('A', 'B')
                );
                SET @Nav =
                (
                    SELECT SUM(amount)
                    FROM tbl_VehicleNavLimitedPartner clp
                         JOIN tbl_VehicleNav c ON c.VehicleNavID = clp.VehicleNavID
                         JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                                     AND vs.ExportChart = 1
                    WHERE c.VehicleID = @vehicleID
                          AND c.NavDate = @startDate
                          AND vs.ShareName IN('A', 'B')
                );
                INSERT INTO @tbl
                       SELECT ISNULL(@Calls, 0) / 1000000, 
                              ISNULL(@Distributions, 0) / 1000000, 
                              ISNULL(@Nav, 0) / 1000000, 
                              @startDate;
                SET @startDate = DATEADD(year, 1, @startDate);
            END;
        SELECT *
        FROM @tbl;
    END;
