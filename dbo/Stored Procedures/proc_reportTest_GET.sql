-- tbl_vehicle    
-- [proc_reportTest_GET] 8                    

CREATE PROCEDURE [dbo].[proc_reportTest_GET](@fundID INT)
AS
    BEGIN
        DECLARE @tblPortfolio TABLE
        (ID          INT, 
         vehicleID   INT, 
         portfolioid INT
        );
        DECLARE @tblRatio TABLE
        (holding             DECIMAL(18, 2), 
         detentionRatio      DECIMAL(18, 2), 
         totalDetentionRatio DECIMAL(18, 2), 
         portfolioid         INT, 
         vehicleID           INT
        );
        INSERT INTO @tblPortfolio
        (ID, 
         portfolioid, 
         vehicleID
        )
               SELECT ROW_NUMBER() OVER(
                      ORDER BY p.portfolioid), 
                      p.portfolioid, 
                      pv.VehicleID
               FROM tbl_Portfolio p
                    INNER JOIN tbl_PortfolioVehicle pv ON p.portfolioid = pv.portfolioid
                    INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
                    LEFT OUTER JOIN tbl_CompanyBusinessUpdates cb ON cb.CompanyID = p.TargetPortfolioID
                                                                     AND cb.Date >= GETDATE()
                    LEFT OUTER JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = p.Portfolioid
                    LEFT OUTER JOIN tbl_Eligibility e ON e.objectmoduleid = p.Portfolioid
                                                         AND e.vehicleid = @fundID
                                                         AND e.moduleid = 7
               WHERE pv.VehicleID = @fundID
                     AND pv.STATUS IN(1, 2, 3, 4)
                    AND p.PortfolioID IN
               (
                   SELECT *
                   FROM dbo.[F_CheckEligibility](@fundID)
                   UNION ALL
                   SELECT pc.portfolioid
                   FROM tbl_Portfolio pc
                        JOIN tbl_portfolioVehicle vv ON pc.PortfolioID = vv.PortfolioID
                   WHERE vv.VehicleID = @fundID
                         AND vv.STATUS = 4
               );
        DECLARE @current INT;
        DECLARE @count INT;
        DECLARE @portfolioID INT;
        DECLARE @vehicleID INT;
        SET @count =
        (
            SELECT COUNT(1)
            FROM @tblPortfolio
        );
        SET @current = 1;
        WHILE(@current <= @count)
            BEGIN
                SELECT @portfolioID = portfolioid, 
                       @vehicleID = vehicleID
                FROM @tblPortfolio
                WHERE ID = @current;
                INSERT INTO @tblRatio
                EXEC [dbo].[proc_GetPortfolioRatio] 
                     @portfolioID, 
                     @vehicleID;
                SET @current = @current + 1;
            END;
        SELECT *,
               CASE
                   WHEN ISNULL([Stock of security], 0) = 0
                   THEN ''
                   ELSE CAST(CAST([Amount invested] / [Stock of security] AS DECIMAL(18, 2)) AS VARCHAR(100))
               END 'Cost'
        FROM
        (
            SELECT DISTINCT 
                   p.Portfolioid, 
                   p.TargetPortfolioID, 
                   pv.VehicleID, 
                   cc.CompanyName, 
                   e.QuotationID, 
                   cc.CompanyBusinessDesc AS 'Business description', 
                   cb.Comments AS 'Business update', 
                   ps.PortfolioSecurityID, 
                   ps.Name AS 'Security Name', 
                   ps.ISIN, 
                   pst.PortfolioSecurityTypeName, 
                   ISNULL(
            (
                SELECT SUM(amount)
                FROM tbl_PortfolioShareholdingOperations spo
                WHERE spo.ToTypeID = 3
                      AND spo.ToID = @fundID
                      AND spo.PortfolioID = p.portfolioid
                      AND spo.SecurityID IN(ps.PortfolioSecurityID)
            ), 0) * 1.0000 - CAST(ISNULL((CAST(
            (
            (
                SELECT SUM(amount)
                FROM tbl_PortfolioShareholdingOperations sho
                WHERE sho.ToTypeID = 3
                      AND sho.TOID = @fundID
                      AND sho.PortfolioID = p.portfolioid
                      AND sho.SecurityID IN(ps.PortfolioSecurityID)
            )
            ) AS DECIMAL(18, 2)) /
            (
            (
                SELECT CASE
                           WHEN SUM(Number) = 0
                           THEN 1
                           ELSE SUM(Number)
                       END
                FROM tbl_PortfolioShareholdingOperations sho
                WHERE sho.TOTypeID = 3
                      AND sho.TOID = @fundID
                      AND sho.PortfolioID = p.portfolioid
                      AND sho.SecurityID IN(ps.PortfolioSecurityID)
            )
            ) *
            (
                SELECT SUM(number)
                FROM tbl_PortfolioShareholdingOperations sho
                WHERE sho.FromTypeID = 3
                      AND sho.FromID = @fundID
                      AND sho.PortfolioID = p.portfolioid
                      AND sho.SecurityID IN(ps.PortfolioSecurityID)
            )), 0) AS DECIMAL(18, 6)) AS 'Amount invested', 
                   ISNULL(
            (
                SELECT SUM(amount)
                FROM tbl_PortfolioShareholdingOperations spo
                WHERE spo.FromTypeID = 3
                      AND spo.FromID = @fundID
                      AND spo.PortfolioID = p.portfolioid
                      AND spo.SecurityID IN(ps.PortfolioSecurityID)
            ), 0) AS 'Amount divestment', 
                   d.Amount AS 'Total Amount invested', 
                   ISNULL(
            (
                SELECT SUM(amount)
                FROM tbl_PortfolioShareholdingOperations spo
                WHERE spo.FromTypeID = 3
                      AND spo.PortfolioID = p.portfolioid
                      AND spo.SecurityID IN(ps.PortfolioSecurityID)
            ), 0) AS 'Total Amount divestment', 
                   (ISNULL(
            (
                SELECT SUM(Number)
                FROM tbl_PortfolioShareholdingOperations
                WHERE ToTypeID = 3
                      AND ToID = @fundID
                      AND PortfolioID = p.portfolioid
                      AND securityid IN(ps.PortfolioSecurityID)
            ), 0) - ISNULL(
            (
                SELECT SUM(Number)
                FROM tbl_PortfolioShareholdingOperations
                WHERE FromTypeID = 3
                      AND FromID = @fundID
                      AND PortfolioID = p.portfolioid
                      AND securityid IN(ps.PortfolioSecurityID)
            ), 0)) AS 'Number of securities by the fund in security', 
                   ISNULL(
            (
                SELECT TOP 1 pvd.value
                FROM tbl_PortfolioValuation pv
                     INNER JOIN tbl_PortfolioValuationDetails pvd ON pv.ValuationID = pvd.ValuationID
                WHERE pv.vehicleid = @fundID
                      AND pv.portfolioid = p.portfolioid
                      AND pvd.securityid IN(ps.PortfolioSecurityID)
                ORDER BY date DESC
            ), 0) AS 'Recent Valuation value by security', 
                   (ISNULL(
            (
                SELECT SUM(Number)
                FROM tbl_PortfolioShareholdingOperations
                WHERE ToTypeID = 3
                      AND PortfolioID = p.portfolioid
                      AND securityid IN(ps.PortfolioSecurityID)
            ), 0) - ISNULL(
            (
                SELECT SUM(Number)
                FROM tbl_PortfolioShareholdingOperations
                WHERE FromTypeID = 3
                      AND PortfolioID = p.portfolioid
                      AND securityid IN(ps.PortfolioSecurityID)
            ), 0)) AS 'Number of securities by all funds in security', 
                   ((ISNULL(
            (
                SELECT SUM(Number)
                FROM tbl_PortfolioShareholdingOperations
                WHERE ToTypeID = 3
                      AND ToID = @fundID
                      AND PortfolioID = p.portfolioid
                      AND securityid IN(ps.PortfolioSecurityID)
            ), 0) - ISNULL(
            (
                SELECT SUM(Number)
                FROM tbl_PortfolioShareholdingOperations
                WHERE FromTypeID = 3
                      AND FromID = @fundID
                      AND PortfolioID = p.portfolioid
                      AND securityid IN(ps.PortfolioSecurityID)
            ), 0)) * ISNULL(
            (
                SELECT TOP 1 pvd.value
                FROM tbl_PortfolioValuation pv
                     INNER JOIN tbl_PortfolioValuationDetails pvd ON pv.ValuationID = pvd.ValuationID
                WHERE pv.vehicleid = @fundID
                      AND pv.portfolioid = p.portfolioid
                      AND pvd.securityid IN(ps.PortfolioSecurityID)
                ORDER BY date DESC
            ), 0)) AS 'Valuation of fund', 
                   ((ISNULL(
            (
                SELECT SUM(Number)
                FROM tbl_PortfolioShareholdingOperations
                WHERE ToTypeID = 3
                      AND PortfolioID = p.portfolioid
                      AND securityid IN(ps.PortfolioSecurityID)
            ), 0) - ISNULL(
            (
                SELECT SUM(Number)
                FROM tbl_PortfolioShareholdingOperations
                WHERE FromTypeID = 3
                      AND PortfolioID = p.portfolioid
                      AND securityid IN(ps.PortfolioSecurityID)
            ), 0)) * ISNULL(
            (
                SELECT TOP 1 pvd.value
                FROM tbl_PortfolioValuation pv
                     INNER JOIN tbl_PortfolioValuationDetails pvd ON pv.ValuationID = pvd.ValuationID
                WHERE pv.portfolioid = p.portfolioid
                      AND pvd.securityid IN(ps.PortfolioSecurityID)
                ORDER BY date DESC
            ), 0)) AS 'Total Valuation of fund', 
                   tr.detentionRatio, 
                   tr.totalDetentionRatio, 
                   ISNULL(
            (
                SELECT TOP 1 pvd.value
                FROM tbl_PortfolioValuation pv
                     INNER JOIN tbl_PortfolioValuationDetails pvd ON pv.ValuationID = pvd.ValuationID
                WHERE pv.vehicleid = @fundID
                      AND pv.portfolioid = p.portfolioid
                      AND pvd.securityid IN(ps.PortfolioSecurityID)
                ORDER BY date DESC
            ), 0) AS 'Last value per security', 
                   ISNULL(
            (
                SELECT TOP 1 pv.Date
                FROM tbl_PortfolioValuation pv
                     INNER JOIN tbl_PortfolioValuationDetails pvd ON pv.ValuationID = pvd.ValuationID
                WHERE pv.vehicleid = @fundID
                      AND pv.portfolioid = p.portfolioid
                      AND pvd.securityid IN(ps.PortfolioSecurityID)
                ORDER BY date DESC
            ), 0) AS 'Last date per security', 
                   ISNULL(dbo.F_GetNetAssetValue(@fundID, GETDATE()), 1) AS 'Net Asset Value', 
                   ISNULL(
            (
                SELECT TOP 1 vc.Amount
                FROM tbl_Vehiclecash vc
                WHERE vc.VehicleID = @fundID
                ORDER BY vc.Date DESC
            ), 0) AS 'Vehicle Cash Amount', 
                   ISNULL(
            (
                SELECT TOP 1 vc.Date
                FROM tbl_Vehiclecash vc
                WHERE vc.VehicleID = @fundID
                ORDER BY vc.Date DESC
            ), NULL) AS 'Vehicle Cash Date', 
                   (ISNULL(
            (
                SELECT SUM(Number)
                FROM tbl_PortfolioShareholdingOperations spo
                WHERE spo.ToTypeID = 3
                      AND spo.ToID = @fundID
                      AND spo.PortfolioID = p.portfolioid
                      AND spo.SecurityID IN(ps.PortfolioSecurityID)
            ), 0) - ISNULL(
            (
                SELECT SUM(Number)
                FROM tbl_PortfolioShareholdingOperations sho
                WHERE sho.FromTypeID = 3
                      AND sho.FromID = @fundID
                      AND sho.PortfolioID = p.portfolioid
                      AND sho.SecurityID IN(ps.PortfolioSecurityID)
            ), 0)) AS 'Stock of security'
            FROM tbl_Portfolio p
                 INNER JOIN tbl_PortfolioVehicle pv ON p.portfolioid = pv.portfolioid
                 INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
                 LEFT OUTER JOIN tbl_CompanyBusinessUpdates cb ON cb.CompanyID = p.TargetPortfolioID
                                                                  AND cb.Date <= GETDATE()
                 LEFT OUTER JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = p.Portfolioid
                 LEFT OUTER JOIN tbl_Eligibility e ON e.objectmoduleid = p.Portfolioid
                                                      AND e.vehicleid = @fundID
                                                      AND e.moduleid = 7
                 LEFT OUTER JOIN @tblRatio tr ON tr.portfolioid = p.PortfolioID
                                                 AND tr.vehicleID = @fundID
                 LEFT JOIN dbo.F_CostOfSolInvs() d ON d.CompanyID = cc.CompanyContactID
                                                      AND d.securityid = ps.PortfolioSecurityID
                 INNER JOIN tbl_PortfolioSecurityType pst ON pst.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
            WHERE pv.VehicleID = @fundID
                  AND pv.STATUS IN(1, 2, 3, 4)
                 AND p.PortfolioID IN
            (
                SELECT *
                FROM dbo.[F_CheckEligibility](@fundID)
                UNION ALL
                SELECT pc.portfolioid
                FROM tbl_Portfolio pc
                     JOIN tbl_portfolioVehicle vv ON pc.PortfolioID = vv.PortfolioID
                WHERE vv.VehicleID = @fundID
                      AND vv.STATUS = 4
            )
        ) t
        ORDER BY t.QuotationID, 
                 t.companyname ASC;
    END;
