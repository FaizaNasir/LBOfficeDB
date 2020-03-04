
--  test 1093,3265,632,'03-01-2017'     

CREATE FUNCTION [dbo].[F_GetDatedNAV]
(@vehicleid   INT, 
 @portfolioid INT, 
 @companyID   INT, 
 @Date        DATETIME
)
RETURNS INT
AS
     BEGIN
         IF @companyID IS NULL
             SET @companyID =
             (
                 SELECT targetportfolioid
                 FROM tbl_portfolio
                 WHERE portfolioid = @portfolioid
             );
         DECLARE @temp1 TABLE
         (companyid   INT, 
          companyname VARCHAR(100), 
          portfolioid INT
         );
         INSERT INTO @temp1
                SELECT DISTINCT 
                       p.TargetPortfolioID, 
                       c.CompanyName, 
                       p.PortfolioID
                FROM tbl_PortfolioVehicle pv
                     JOIN tbl_Portfolio p ON pv.PortfolioID = p.PortfolioID
                     JOIN tbl_companycontact c ON c.CompanyContactID = p.TargetPortfolioID
                WHERE VehicleID = @vehicleID
                      AND STATUS IN(1, 2, 3);
         DECLARE @holding TABLE
         (companyid         INT, 
          portfolioid       INT, 
          holdingCompanyID1 INT, 
          holdingCompanyID2 INT, 
          ModuleID1         INT, 
          ModuleID2         INT, 
          IsHolding1        BIT, 
          IsHolding2        BIT
         );
         INSERT INTO @holding
                SELECT t.companyid, 
                       p.portfolioid, 
                       s1.ObjectID, 
                       s2.ObjectID, 
                       s1.ModuleID, 
                       s2.ModuleID, 
                       (CASE
                            WHEN EXISTS
                (
                    SELECT TOP 1 1
                    FROM tbl_PortfolioVehicle pv
                         JOIN tbl_portfolio h1 ON h1.PortfolioID = pv.portfolioid
                    WHERE h1.TargetPortfolioID = s1.ObjectID
                          AND s1.ModuleID = 5
                          AND pv.VehicleID = @vehicleID
                )
                            THEN 1
                            ELSE 0
                        END), 
                       (CASE
                            WHEN EXISTS
                (
                    SELECT TOP 1 1
                    FROM tbl_PortfolioVehicle pv
                         JOIN tbl_portfolio h2 ON h2.PortfolioID = pv.portfolioid
                    WHERE h2.TargetPortfolioID = s2.ObjectID
                          AND s2.ModuleID = 5
                          AND pv.VehicleID = @vehicleID
                )
                            THEN 1
                            ELSE 0
                        END)
                FROM
                (
                    SELECT *
                    FROM @temp1
                ) t
                JOIN tbl_ShareholdersOwned s1 ON s1.TargetPortfolioID = t.companyid
                                                 AND s1.ModuleID = 5
                                                 AND ShareholderOwnedDateId =
                (
                    SELECT TOP 1 ShareholderDateId
                    FROM tbl_ShareholdersOwnedDate
                    WHERE TargetPortfolioId = t.companyid
                    ORDER BY date DESC
                )
                JOIN tbl_Portfolio p ON p.TargetPortfolioID = s1.ObjectID
                LEFT JOIN tbl_ShareholdersOwned s2 ON s2.TargetPortfolioID = s1.ObjectID
                                                      AND s2.ShareholderOwnedDateId =
                (
                    SELECT TOP 1 ShareholderDateId
                    FROM tbl_ShareholdersOwnedDate
                    WHERE TargetPortfolioId = s1.ObjectID
                    ORDER BY date DESC
                );
         UPDATE h
           SET 
               ModuleID2 = 3, 
               Isholding2 = 1, 
               holdingCompanyID2 = @vehicleID
         FROM @holding h
         WHERE ModuleID2 IS NULL
               AND NOT EXISTS
         (
             SELECT TOP 1 1
             FROM tbl_ShareholdersOwned s
             WHERE s.objectid = h.companyID
                   AND s.moduleid = 5
                   AND ShareholderOwnedDateId =
             (
                 SELECT TOP 1 ShareholderDateId
                 FROM tbl_ShareholdersOwnedDate
                 WHERE TargetPortfolioId = h.companyid
                 ORDER BY date DESC
             )
         );
         UPDATE h
           SET 
               ModuleID1 = 3, 
               IsHolding1 = 1, 
               holdingCompanyID1 = @vehicleID
         FROM @holding h
         WHERE ModuleID1 IS NULL;
         DECLARE @nav DECIMAL(18, 2);
         DECLARE @navDate DATETIME;
         DECLARE @divestment DECIMAL(18, 2);
         DECLARE @Investment DECIMAL(18, 2);
         DECLARE @CapitalIncrease DECIMAL(18, 2);
         SELECT TOP 1 @nav = FinalValuation, 
                      @navDate = pso.Date
         FROM tbl_PortfolioValuation pso
              JOIN @holding h ON pso.portfolioid = CASE
                                                       WHEN h.ModuleID2 = 5
                                                       THEN h.PortfolioID
                                                       WHEN h.ModuleID2 = 3
                                                       THEN @portfolioid
                                                   END
         WHERE h.companyid = @companyID
               AND pso.Date <= @date
               AND pso.VehicleID = @vehicleID
         ORDER BY Date DESC;
         SET @divestment =
         (
             SELECT CAST(CASE
                             WHEN EXISTS
             (
                 SELECT TOP 1 1
                 FROM @holding h
                 WHERE h.companyid = @companyID
             )
                             THEN
             (
                 SELECT ISNULL(SUM(Amount), 0)
                 FROM tbl_PortfolioShareholdingOperations pso
                      JOIN @holding h ON pso.portfolioid = CASE
                                                               WHEN h.ModuleID2 = 5
                                                               THEN h.PortfolioID
                                                               WHEN h.ModuleID2 = 3
                                                               THEN @portfolioid
                                                           END
                 WHERE h.companyid = @companyID
                       AND 1 = CASE
                                   WHEN FromTypeID = h.ModuleID2
                                        AND FromID = h.holdingCompanyID2
                                   THEN 1
                               END
                       AND ISNULL(isConditional, 0) = 0
                       AND pso.Date >= @navDate
             )
                             ELSE
             (
                 SELECT ISNULL(SUM(Amount), 0)
                 FROM tbl_PortfolioShareholdingOperations pso
                 WHERE pso.PortfolioID = @portfolioID
                       AND FromTypeID = 3
                       AND FromID = @vehicleID
                       AND ISNULL(isConditional, 0) = 0
                       AND pso.Date >= @navDate
             )
                         END AS DECIMAL(18, 2)) + CAST(
             (
                 SELECT ISNULL(SUM(Amount), 0)
                 FROM tbl_PortfolioGeneralOperation g
                      JOIN @holding h ON g.portfolioid = CASE
                                                             WHEN h.ModuleID2 = 5
                                                             THEN h.PortfolioID
                                                             WHEN h.ModuleID2 = 3
                                                             THEN @portfolioid
                                                         END
                 WHERE h.companyid = @companyID
                       AND ISNULL(g.isConditional, 0) = 0
                       AND (h.isholding2 = 1
                            OR h.ModuleID2 = 3)
                       AND g.Date >= @navDate
             ) AS DECIMAL(18, 2))
         );
         RETURN @nav * 1.0 - @divestment;
     END;
