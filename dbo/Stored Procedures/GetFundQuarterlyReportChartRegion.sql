
CREATE PROC [dbo].[GetFundQuarterlyReportChartRegion]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        DECLARE @tbl TABLE
        (Region   VARCHAR(1000), 
         RegionFr VARCHAR(1000), 
         Amount   DECIMAL(18, 2)
        );
        INSERT INTO @tbl
               SELECT Region, 
                      RegionFr, 
                      SUM(amount) Amount
               FROM
               (
                   SELECT SUM(sho.Amount) Amount, 
                          sho.PortfolioID
                   FROM tbl_PortfolioVehicle pv
                        JOIN tbl_PortfolioShareholdingOperations sho ON sho.PortfolioID = pv.PortfolioID
                   WHERE pv.VehicleID = @vehicleID
                         AND sho.date <= @date
                         AND ToTypeID = 3
                         AND toID = @vehicleID
                   GROUP BY sho.PortfolioID
                   UNION ALL
                   SELECT SUM(sho.Amount) Amount, 
                          sho.PortfolioID
                   FROM tbl_PortfolioVehicle pv
                        JOIN tbl_PortfolioGeneralOperation sho ON sho.PortfolioID = pv.PortfolioID
                   WHERE pv.VehicleID = @vehicleID
                         AND sho.date <= @date
                         AND ToModuleID = 3
                         AND toID = @vehicleID
                         AND sho.TypeID IN(1, 3, 7, 8)
                   GROUP BY sho.PortfolioID
               ) t
               JOIN tbl_PortfolioOptional po ON po.PortfolioID = t.PortfolioID
               GROUP BY po.Region, 
                        po.RegionFr;
        SELECT ISNULL(Region, 'Other') Region, 
               ISNULL(RegionFr, 'Autres') RegionFr, 
               Amount, 
               CAST(100 * Amount /
        (
            SELECT SUM(amount)
            FROM @tbl
        ) AS DECIMAL(18, 2)) Per
        FROM @tbl
        ORDER BY Per DESC;
    END;
