CREATE PROCEDURE [dbo].[proc_PortfolioPerformanceExits_Vehicle] @vehicleID INT          = NULL, 
                                                                @userrole  VARCHAR(100) = NULL, 
                                                                @date      DATETIME
AS
    BEGIN
        DECLARE @portfolios TABLE
        (PortfolioID       INT, 
         TargetPortfolioID INT
        );
        INSERT INTO @portfolios
               SELECT pv.PortfolioID, 
                      p.TargetPortfolioID
               FROM tbl_PortfolioVehicle pv
                    INNER JOIN tbl_Portfolio p ON pv.PortfolioID = p.PortfolioID
               WHERE pv.vehicleID = @vehicleID
                     AND STATUS = 4;
        DECLARE @tblvaluation TABLE
        (CompanyName VARCHAR(100), 
         PortfolioID INT, 
         date        DATETIME, 
         Amount      DECIMAL(18, 2), 
         Type        VARCHAR(100)
        );
        INSERT INTO @tblvaluation
               SELECT
               (
                   SELECT companyname
                   FROM tbl_CompanyContact cc
                   WHERE cc.CompanyContactID = p.TargetPortfolioID
               ), 
               p.PortfolioID, 
               ISNULL(
               (
                   SELECT TOP 1 Date
                   FROM tbl_PortfolioValuation
                   WHERE portfolioid IN
                   (
                       SELECT PortfolioID
                       FROM @portfolios
                   )
                         AND VehicleID = pv.VehicleID
                         AND date <= @date
                   ORDER BY Date DESC
               ), 0), 
               ISNULL(
               (
                   SELECT TOP 1 FinalValuation
                   FROM tbl_PortfolioValuation
                   WHERE portfolioid = pv.PortfolioID
                         AND VehicleID = pv.VehicleID
                         AND date <= @date
                   ORDER BY Date DESC
               ), 0), 
               'Valuation'
               FROM tbl_portfolio p
                    JOIN tbl_portfoliovehicle pv ON p.PortfolioID = pv.PortfolioID
               WHERE pv.portfolioid IN
               (
                   SELECT PortfolioID
                   FROM @portfolios
               )
                     AND pv.[Status] IN(1, 2, 4)
                    AND pv.VehicleID = @vehicleID
                    AND EXISTS
               (
                   SELECT TOP 1 1
                   FROM tbl_PortfolioValuation pval
                   WHERE pval.PortfolioID = pv.PortfolioID
                         AND pval.VehicleID = pv.VehicleID
                         AND date <= @date
                         AND ISNULL(pval.Active, 1) = 1
               );
        SELECT *,
               CASE
                   WHEN OperationTypeID = 0
                        AND FromTypeID = 0
                        AND ToTypeID = 3
                   THEN 'Capital increase'
                   WHEN OperationTypeID = 0
                        AND FromTypeID <> 0
                        AND ToTypeID = 3
                   THEN 'Investment'
                   WHEN OperationTypeID = 0
                        AND FromTypeID = 3
                        AND ToTypeID <> 0
                   THEN 'Divestment'
                   WHEN OperationTypeID = 0
                        AND FromTypeID = 3
                        AND ToTypeID = 0
                   THEN 'Divestment'
                   WHEN OperationTypeID <> 0
                   THEN ISNULL(
        (
            SELECT TypeName
            FROM tbl_PortfolioGeneralOperationType
            WHERE TypeID = OperationTypeID
        ), '')
                   WHEN OperationTypeID = 0
                        AND Category = 'Valuation'
                   THEN 'Last Valuation'
                   ELSE ''
               END Type
        FROM
        (
            SELECT
            (
                SELECT TOP 1 companyname
                FROM tbl_CompanyContact cc
                WHERE cc.CompanyContactID = p.TargetPortfolioID
            ) Company, 
            p.PortfolioID, 
            Date, 
            -1 * amount Amount, 
            'ShareholdingOperations' AS Category, 
            0 OperationTypeID, 
            toTypeID, 
            FromTypeID
            FROM tbl_PortfolioShareholdingOperations s
                 INNER JOIN @portfolios p ON s.PortfolioID = p.PortfolioID
            WHERE toTypeID = 3
                  AND toid = @vehicleID
                  AND date <= @date
                  AND p.portfolioid IN
            (
                SELECT PortfolioID
                FROM @portfolios
            )
                  AND ISNULL(IsConditional, 0) = 0
            UNION ALL
            SELECT
            (
                SELECT TOP 1 companyname
                FROM tbl_CompanyContact cc
                WHERE cc.CompanyContactID = p.TargetPortfolioID
            ) Company, 
            s.PortfolioID, 
            date, 
            -1 * amount, 
            'GeneralOperation', 
            TypeID, 
            ToModuleID, 
            FromModuleID
            FROM tbl_PortfolioGeneralOperation s
                 INNER JOIN @portfolios p ON s.PortfolioID = p.PortfolioID
            WHERE fromModuleID = 3
                  AND fromid = @vehicleID
                  AND date <= @date
                  AND s.portfolioid IN
            (
                SELECT PortfolioID
                FROM @portfolios
            )
                  AND ISNULL(IsConditional, 0) = 0
            UNION ALL
            SELECT
            (
                SELECT TOP 1 companyname
                FROM tbl_CompanyContact cc
                WHERE cc.CompanyContactID = p.TargetPortfolioID
            ) Company, 
            s.PortfolioID, 
            date, 
            amount, 
            'ShareholdingOperations', 
            0, 
            toTypeID, 
            FromTypeID
            FROM tbl_PortfolioShareholdingOperations s
                 INNER JOIN @portfolios p ON s.PortfolioID = p.PortfolioID
            WHERE fromTypeID = 3
                  AND fromid = @vehicleID
                  AND date <= @date
                  AND s.portfolioid IN
            (
                SELECT PortfolioID
                FROM @portfolios
            )
                  AND ISNULL(IsConditional, 0) = 0
            UNION ALL
            SELECT
            (
                SELECT TOP 1 companyname
                FROM tbl_CompanyContact cc
                WHERE cc.CompanyContactID = p.TargetPortfolioID
            ) Company, 
            s.PortfolioID, 
            date, 
            amount, 
            'GeneralOperation', 
            TypeID, 
            ToModuleID, 
            FromModuleID
            FROM tbl_PortfolioGeneralOperation s
                 INNER JOIN @portfolios p ON s.PortfolioID = p.PortfolioID
            WHERE toModuleID = 3
                  AND toid = @vehicleID
                  AND date <= @date
                  AND s.portfolioid IN
            (
                SELECT PortfolioID
                FROM @portfolios
            )
                  AND ISNULL(IsConditional, 0) = 0
            UNION ALL
            SELECT *, 
                   0, 
                   0, 
                   0
            FROM @tblvaluation
        ) t
        ORDER BY t.Date;
    END;
