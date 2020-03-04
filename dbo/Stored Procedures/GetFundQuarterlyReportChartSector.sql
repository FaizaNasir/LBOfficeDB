CREATE PROC [dbo].[GetFundQuarterlyReportChartSector]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        DECLARE @tbl TABLE
        (Sector   VARCHAR(1000), 
         SectorFr VARCHAR(1000), 
         Amount   DECIMAL(18, 2)
        );
        INSERT INTO @tbl
               SELECT BusinessAreaTitle, 
                      BusinessAreaTitleFr, 
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
               JOIN tbl_portfolio p ON p.PortfolioID = t.PortfolioID
               JOIN tbl_companycontact cc ON cc.companycontactid = p.TargetPortfolioID
               JOIN tbl_BusinessArea ba ON ba.BusinessAreaID = cc.CompanyBusinessAreaID
               GROUP BY ba.BusinessAreaTitle, 
                        BusinessAreaTitleFr;
        SELECT ISNULL(Sector, 'Other') Sector, 
               ISNULL(SectorFr, 'Autres') SectorFr, 
               Amount, 
               CAST(100 * Amount /
        (
            SELECT SUM(amount)
            FROM @tbl
        ) AS DECIMAL(18, 2)) Per
        FROM @tbl
        ORDER BY Per DESC;
    END;
