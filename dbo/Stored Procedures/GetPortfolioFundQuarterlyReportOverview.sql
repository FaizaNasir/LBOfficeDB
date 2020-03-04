CREATE PROC [dbo].[GetPortfolioFundQuarterlyReportOverview]
(@vehicleid INT, 
 @date      DATETIME
)
AS
    BEGIN
        SELECT v.Name, 
               ISNULL(v.IsExit, 0) IsExit, 
               dbo.[F_GetActivityName](v.vehicleid) ActivityName, 
               sho.*, 
               nav.*, 
               sho.Distributions + nav.NAV TotalValue,
               CASE
                   WHEN ISNULL(Contributions, 0) <> 0
                   THEN(sho.Distributions + nav.NAV) / Contributions
                   ELSE 0
               END TVPI
        FROM tbl_VehiclePortfolioFund pv
             JOIN tbl_vehicle v
             OUTER APPLY
        (
            SELECT MIN(sho.Date) Date, 
                   ISNULL(SUM(CASE
                                  WHEN typeid = 1
                                  THEN amount
                                  ELSE 0
                              END), 0) / 1000000 Commitments, 
                   ISNULL(SUM(CASE
                                  WHEN typeid = 2
                                  THEN amount
                                  ELSE 0
                              END), 0) / 1000000 Contributions, 
                   ISNULL(SUM(CASE
                                  WHEN typeid = 3
                                  THEN amount
                                  ELSE 0
                              END), 0) / 1000000 Distributions, 
                   0 * (ISNULL(SUM(CASE
                                       WHEN typeid = 2
                                       THEN amount
                                       ELSE 0
                                   END), 0) - ISNULL(SUM(CASE
                                                             WHEN typeid = 1
                                                             THEN amount
                                                             ELSE 0
                                                         END), 0)) / 1000000 UndrawnCommitments
            FROM tbl_PortfolioFundGeneralOperation sho
            WHERE sho.VehicleID = v.VehicleID
                  AND sho.Date <= @date
        ) sho
             OUTER APPLY
        (
            SELECT TOP 1 NAV / 1000000 NAV
            FROM tbl_PortfolioFundNav pfn
            WHERE pfn.VehicleID = v.VehicleID
                  AND pfn.Date <= @date
            ORDER BY date DESC
        ) nav ON v.VehicleID = pv.PortfolioFundID
        WHERE pv.VehicleID = @vehicleid;
    END;
