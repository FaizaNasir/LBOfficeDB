CREATE PROC [dbo].[GetPortfolioFundReportChart]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        DECLARE @tbl TABLE
        (ActiviteName VARCHAR(100), 
         Amount       DECIMAL(18, 2)
        );
        INSERT INTO @tbl
               SELECT ActiviteName, 
                      SUM(sho.Amount) Amount
               FROM tbl_PortfolioFundGeneralOperation sho
                    JOIN tbl_VehiclePortfolioFund pv ON pv.PortfolioFundID = sho.VehicleID
                    JOIN tbl_vehicle v ON v.VehicleID = sho.VehicleID
                    LEFT JOIN tbl_VehicleActivity va ON va.VehicleID = v.VehicleID
                    JOIN tbl_Activities a ON a.ActiviteID = va.ActivityId
               WHERE sho.TypeID = 1
                     AND pv.VehicleID = @vehicleID
                     AND sho.Date <= @date
               GROUP BY ActiviteName;
        DECLARE @total DECIMAL(18, 2);
        SET @total =
        (
            SELECT SUM(Amount)
            FROM @tbl
        );
        SELECT ActiviteName, 
               CAST(100 * Amount / @total AS DECIMAL(18, 2)) Amount
        FROM @tbl
        ORDER BY Amount DESC;
    END;
