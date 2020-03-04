CREATE PROCEDURE [dbo].[proc_Portfolio_Shareholder_ByPortfolio_GET_V1] @TargetPortfolioID INT      = NULL, 
                                                                     @FundID            INT      = NULL, 
                                                                     @date              DATETIME
AS
    BEGIN
        DECLARE @navDate DATETIME;
        SET @navDate =
        (
            SELECT TOP 1 pso.Date
            FROM tbl_PortfolioValuation pso
                 JOIN tbl_Portfolio p ON p.PortfolioID = pso.PortfolioID
            WHERE p.TargetPortfolioID = @TargetPortfolioID
                  AND pso.VehicleID = @FundID
                  AND pso.Date < @date
            ORDER BY Date DESC
        );
        DECLARE @tblHolding TABLE(ID INT);
        INSERT INTO @tblHolding
               SELECT p.TargetPortfolioID
               FROM tbl_portfolio p
                    JOIN tbl_ShareholdersOwned oo ON oo.ObjectID = p.TargetPortfolioID
                                                     AND ShareholderOwnedDateId =
               (
                   SELECT TOP 1 ShareholderDateId
                   FROM tbl_ShareholdersOwnedDate
                   WHERE TargetPortfolioId = @TargetPortfolioID
                   ORDER BY date DESC
               )
               WHERE oo.TargetPortfolioID = @TargetPortfolioID;
        SELECT ROW_NUMBER() OVER(
               ORDER BY p.PortfolioID ASC) AS RowNum, 
               p.TargetPortfolioID CompanyID, 
               p.PortfolioID, 
               0 AS 'ShareholderID', 
               0 ModuleID, 
               0 'ObjectID', 
               p.TargetPortfolioID 'TargetPortfolioID', 
               '' 'Individual Name', 
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = p.TargetPortfolioID
        ) 'Company Name', 
               p.Active, 
               p.CreatedDateTime, 
               p.ModifiedDateTime, 
               p.CreatedBy, 
               p.ModifiedBy, 
        (
            SELECT TOP 1 ClosingDate
            FROM
            (
                SELECT TOP 1 date ClosingDate
                FROM tbl_PortfolioShareholdingOperations sho
                     JOIN tbl_portfolio pp ON pp.PortfolioID = sho.PortfolioID
                WHERE pp.TargetPortfolioID = @TargetPortfolioID
                      AND sho.Date < @date
                      AND 1 = CASE
                                  WHEN ToTypeID = 5
                                       AND ToID IN
                (
                    SELECT *
                    FROM @tblHolding
                )
                                  THEN 1
                              END
                ORDER BY date
                UNION ALL
                SELECT TOP 1 date
                FROM tbl_PortfolioShareholdingOperations sho
                     JOIN tbl_portfolio pp ON pp.PortfolioID = sho.PortfolioID
                WHERE pp.TargetPortfolioID = @TargetPortfolioID
                      AND ToTypeID = 3
                      AND ToID = @FundID
                      AND sho.Date < @date
                ORDER BY date
            ) t
            ORDER BY t.ClosingDate
        ) ClosingDate, 
               ISNULL(
        (
            SELECT TOP 1 CAST(oo.Owned AS VARCHAR(100))
            FROM tbl_ShareholdersOwned oo
                 JOIN @tblHolding h ON oo.ObjectID = h.ID
                                       AND ShareholderOwnedDateId =
            (
                SELECT TOP 1 ShareholderDateId
                FROM tbl_ShareholdersOwnedDate
                WHERE TargetPortfolioId = @TargetPortfolioID
                ORDER BY date DESC
            )
            WHERE oo.TargetPortfolioID = @TargetPortfolioID
        ), '') Owned, 
               ISNULL(CAST((ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
                 JOIN tbl_portfolio pp ON pp.PortfolioID = sho.PortfolioID
            WHERE pp.TargetPortfolioID = @TargetPortfolioID
                  AND sho.Date < @date
                  AND 1 = CASE
                              WHEN ToTypeID = 5
                                   AND ToID IN
            (
                SELECT *
                FROM @tblHolding
            )
                              THEN 1
                          END
        ), 0) + ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
                 JOIN tbl_portfolio pp ON pp.PortfolioID = sho.PortfolioID
            WHERE pp.TargetPortfolioID = @TargetPortfolioID
                  AND sho.Date < @date
                  AND ToTypeID = 3
                  AND ToID = @FundID
        ), 0) + ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation sho
                 JOIN tbl_portfolio pp ON pp.PortfolioID = sho.PortfolioID
            WHERE pp.TargetPortfolioID = @TargetPortfolioID
                  AND sho.Date < @date
                  AND 1 = CASE
                              WHEN ToModuleID = 5
                                   AND ToID IN
            (
                SELECT *
                FROM @tblHolding
            )
                              THEN 1
                              WHEN FromModuleID = 5
                                   AND FromID IN
            (
                SELECT *
                FROM @tblHolding
            )
                              THEN 1
                          END
                  AND sho.TypeID IN(1, 3, 7, 8)
        ), 0) + ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation sho
                 JOIN tbl_portfolio pp ON pp.PortfolioID = sho.PortfolioID
            WHERE pp.TargetPortfolioID = @TargetPortfolioID
                  AND sho.Date < @date
                  AND 1 = CASE
                              WHEN ToModuleID = 3
                                   AND ToID = @FundID
                              THEN 1
                              WHEN FromModuleID = 3
                                   AND FromID = @FundID
                              THEN 1
                          END
                  AND sho.TypeID IN(1, 3, 7, 8)
        ), 0)) AS VARCHAR(100)), '') Investment, 
               ISNULL(CAST((ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
                 JOIN tbl_portfolio pp ON pp.PortfolioID = sho.PortfolioID
            WHERE pp.TargetPortfolioID = @TargetPortfolioID
                  AND sho.Date < @date
                  AND 1 = CASE
                              WHEN FromTypeID = 5
                                   AND FromID IN
            (
                SELECT *
                FROM @tblHolding
            )
                              THEN 1
                          END
        ), 0) + ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
                 JOIN tbl_portfolio pp ON pp.PortfolioID = sho.PortfolioID
            WHERE pp.TargetPortfolioID = @TargetPortfolioID
                  AND sho.Date < @date
                  AND FromTypeID = 3
                  AND FromID = @FundID
        ), 0) + ISNULL(
        (
            SELECT SUM(CASE
                           WHEN typeid IN(4, 5, 6)
                           THEN amount
                           WHEN typeid IN(3, 7, 9)
                           THEN-1 * amount
                       END)
            FROM tbl_PortfolioGeneralOperation sho
                 JOIN tbl_portfolio pp ON pp.PortfolioID = sho.PortfolioID
            WHERE pp.TargetPortfolioID = @TargetPortfolioID
                  AND sho.Date < @date
                  AND 1 = CASE
                              WHEN ToModuleID = 5
                                   AND ToID IN
            (
                SELECT *
                FROM @tblHolding
            )
                              THEN 1
                              WHEN FromModuleID = 5
                                   AND FromID IN
            (
                SELECT *
                FROM @tblHolding
            )
                              THEN 1
                          END
                  AND sho.TypeID IN(1, 3, 7, 8)
        ), 0) + ISNULL(
        (
            SELECT SUM(CASE
                           WHEN typeid IN(4, 5, 6)
                           THEN amount
                           WHEN typeid IN(3, 7, 9)
                           THEN-1 * amount
                       END)
            FROM tbl_PortfolioGeneralOperation sho
                 JOIN tbl_portfolio pp ON pp.PortfolioID = sho.PortfolioID
            WHERE pp.TargetPortfolioID = @TargetPortfolioID
                  AND sho.Date < @date
                  AND 1 = CASE
                              WHEN ToModuleID = 3
                                   AND ToID = @FundID
                              THEN 1
                              WHEN FromModuleID = 3
                                   AND FromID = @FundID
                              THEN 1
                          END
                  AND sho.TypeID IN(1, 3, 7, 8)
        ), 0)) AS VARCHAR(100)), '') Proceeds, 
               CAST(ISNULL(
        (
            SELECT TOP 1 FinalValuation
            FROM tbl_PortfolioValuation pso
            WHERE pso.PortfolioID = p.PortfolioID
                  AND pso.Date <= @date
                  AND pso.VehicleID = @FundID
            ORDER BY Date DESC
        ), 0) - ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.PortfolioID = p.PortfolioID
                  AND FromID = p.TargetPortfolioID
                  AND sho.FromTypeID = 5
                  AND ToID = -2
                  AND sho.Date >= ISNULL(@navDate, sho.Date)
                  AND sho.Date < @date
        ), 0) - ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.PortfolioID = p.PortfolioID
                  AND FromID IN
            (
                SELECT *
                FROM @tblHolding
            )
                  AND sho.FromTypeID = 5
                  AND ToID = -2
                  AND sho.Date >= ISNULL(@navDate, sho.Date)
                  AND sho.Date < @date
        ), 0) + ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.PortfolioID = p.PortfolioID
                  AND ToID = p.TargetPortfolioID
                  AND sho.ToID = 5
                  AND sho.Date >= ISNULL(@navDate, sho.Date)
                  AND sho.Date < @date
        ), 0) + ISNULL(
        (
            SELECT SUM(amount)
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.PortfolioID = p.PortfolioID
                  AND ToID IN
            (
                SELECT *
                FROM @tblHolding
            )
                  AND sho.ToTypeID = 5
                  AND sho.Date >= ISNULL(@navDate, sho.Date)
                  AND sho.Date < @date
        ), 0) AS VARCHAR(100)) Valuation, 
               ba.BusinessAreaTitle Sector
        FROM tbl_Portfolio p
             INNER JOIN tbl_PortfolioVehicle pv ON pv.PortfolioID = p.PortfolioID
             JOIN tbl_CompanyContact cc ON cc.companycontactid = p.TargetPortfolioID
             LEFT JOIN tbl_BusinessArea ba ON ba.BusinessAreaID = cc.CompanyBusinessAreaID
        WHERE pv.VehicleID = @FundID
              AND p.TargetPortfolioID = @TargetPortfolioID;
    END;
