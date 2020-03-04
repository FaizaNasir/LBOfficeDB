CREATE PROCEDURE [dbo].[proc_PortfolioPerformanceForeignCurrencyGet_Vehicle] @vehicleID    INT      = NULL, 
                                                                             @sectorID     INT, 
                                                                             @teamMemberID INT, 
                                                                             @date         DATETIME, 
                                                                             @dealTypeID   INT
AS
    BEGIN
        IF @sectorID = '0'
            SET @sectorID = NULL;
        IF @dealTypeID = '0'
            SET @dealTypeID = NULL;
        IF @teamMemberID = '0'
            SET @teamMemberID = NULL;
        IF @date IS NULL
            SET @date = GETDATE();
        SET @date = CAST(CONVERT(VARCHAR(10), @date, 101) + ' 23:59:59' AS DATETIME);
        DECLARE @portfolios TABLE(PortfolioID INT);
        INSERT INTO @portfolios
               SELECT PortfolioID
               FROM tbl_PortfolioVehicle pv
               WHERE vehicleID = @vehicleID
                     AND EXISTS
               (
                   SELECT TOP 1 1
                   FROM tbl_Portfolio p
                        LEFT JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
                        LEFT JOIN tbl_Deals d ON d.DealCurrentTargetID = cc.CompanyContactID
                        LEFT JOIN tbl_DealTeam dt ON dt.DealID = d.DealID
                        LEFT JOIN tbl_portfolioOptional po ON po.PortfolioID = p.PortfolioID
                   WHERE p.PortfolioID = pv.PortfolioID
                         AND 1 = CASE
                                     WHEN @teamMemberID IS NULL
                                     THEN 1
                                     WHEN dt.IndividualID = ISNULL(@teamMemberID, dt.IndividualID)
                                     THEN 1
                                 END
                         AND 1 = CASE
                                     WHEN @dealTypeID IS NULL
                                     THEN 1
                                     WHEN po.dealTypeID = ISNULL(@dealTypeID, po.dealTypeID)
                                     THEN 1
                                 END
                         AND 1 = CASE
                                     WHEN @sectorID IS NULL
                                     THEN 1
                                     WHEN cc.CompanyBusinessAreaID = ISNULL(@sectorID, cc.CompanyBusinessAreaID)
                                     THEN 1
                                 END
               );
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
                       SELECT *
                       FROM @portfolios
                   )
                         AND VehicleID = pv.VehicleID
                         AND 1 = CASE
                                     WHEN @date IS NULL
                                     THEN 1
                                     WHEN Date < @date
                                     THEN 1
                                     ELSE 0
                                 END
                   ORDER BY Date DESC
               ), 0), 
               ISNULL(
               (
                   SELECT TOP 1 pval.InvestmentValue
                   FROM tbl_PortfolioValuation pval
                   WHERE pval.portfolioid = p.PortfolioID
                         AND pval.VehicleID = pv.VehicleID
                         AND 1 = CASE
                                     WHEN @date IS NULL
                                     THEN 1
                                     WHEN Date < @date
                                     THEN 1
                                     ELSE 0
                                 END
                   ORDER BY Date DESC
               ), 0), 
               'Valuation'
               FROM tbl_portfolio p
                    JOIN tbl_portfoliovehicle pv ON p.PortfolioID = pv.PortfolioID
               WHERE pv.portfolioid IN
               (
                   SELECT *
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
                         AND ISNULL(pval.Active, 1) = 1
                         AND 1 = CASE
                                     WHEN @date IS NULL
                                     THEN 1
                                     WHEN Date < @date
                                     THEN 1
                                     ELSE 0
                                 END
               );
        UPDATE @tblvaluation
          SET 
              date = @date
        WHERE date <= @date;
        SELECT CAST(1 AS BIT) IsInclude, 
               *,
               CASE
                   WHEN OperationTypeID = 0
                        AND FromTypeID = 0
                        AND ToTypeID = 3
                   THEN 'Capital increase'
                   WHEN OperationTypeID = 0
                        AND FromTypeID <> 0
                        AND ToTypeID = 3
                   THEN 'Investment'
                   WHEN OperationTypeID = 2
                        AND ToTypeID = 3
                        AND Category = 'FollowOnPayment'
                   THEN 'Investment'
                   WHEN OperationTypeID = 0
                        AND FromTypeID = 3
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
                SELECT companyname
                FROM tbl_CompanyContact cc
                     JOIN tbl_Portfolio p ON cc.CompanyContactID = p.TargetPortfolioID
                WHERE cc.CompanyContactID = TargetPortfolioID
                      AND p.PortfolioID = s.PortfolioID
            ) Company, 
            PortfolioID, 
            Date, 
            -1 * ISNULL(ForeignCurrencyAmount, Amount) Amount, 
            'ShareholdingOperations' AS Category, 
            0 OperationTypeID, 
            toTypeID, 
            FromTypeID
            FROM tbl_PortfolioShareholdingOperations s
            WHERE toTypeID = 3
                  AND toid = @vehicleID
                  AND portfolioid IN
            (
                SELECT *
                FROM @portfolios
            )
                  AND ISNULL(IsConditional, 0) = 0
            UNION ALL
            SELECT
            (
                SELECT companyname
                FROM tbl_CompanyContact cc
                     JOIN tbl_Portfolio p ON cc.CompanyContactID = p.TargetPortfolioID
                WHERE cc.CompanyContactID = TargetPortfolioID
                      AND p.PortfolioID = s.PortfolioID
            ) Company, 
            PortfolioID, 
            date, 
            -1 * ForeignCurrencyAmount, 
            'GeneralOperation', 
            TypeID, 
            ToModuleID, 
            FromModuleID
            FROM tbl_PortfolioGeneralOperation s
            WHERE fromModuleID = 3
                  AND fromid = @vehicleID
                  AND portfolioid IN
            (
                SELECT *
                FROM @portfolios
            )
                  AND ISNULL(IsConditional, 0) = 0
            UNION ALL
            SELECT
            (
                SELECT companyname
                FROM tbl_CompanyContact cc
                     JOIN tbl_Portfolio p ON cc.CompanyContactID = p.TargetPortfolioID
                WHERE cc.CompanyContactID = TargetPortfolioID
                      AND p.PortfolioID = s.PortfolioID
            ) Company, 
            PortfolioID, 
            date, 
            ISNULL(ForeignCurrencyAmount, Amount), 
            'ShareholdingOperations', 
            0, 
            toTypeID, 
            FromTypeID
            FROM tbl_PortfolioShareholdingOperations s
            WHERE fromTypeID = 3
                  AND fromid = @vehicleID
                  AND portfolioid IN
            (
                SELECT *
                FROM @portfolios
            )
                  AND ISNULL(IsConditional, 0) = 0
            UNION ALL
            SELECT
            (
                SELECT companyname
                FROM tbl_CompanyContact cc
                     JOIN tbl_Portfolio p ON cc.CompanyContactID = p.TargetPortfolioID
                WHERE cc.CompanyContactID = TargetPortfolioID
                      AND p.PortfolioID = s.PortfolioID
            ) Company, 
            PortfolioID, 
            date, 
            ISNULL(ForeignCurrencyAmount, Amount), 
            'GeneralOperation', 
            TypeID, 
            ToModuleID, 
            FromModuleID
            FROM tbl_PortfolioGeneralOperation s
            WHERE toModuleID = 3
                  AND toid = @vehicleID
                  AND portfolioid IN
            (
                SELECT *
                FROM @portfolios
            )
                  AND ISNULL(IsConditional, 0) = 0
            UNION ALL
            SELECT *, 
                   0, 
                   0, 
                   0
            FROM @tblvaluation
            UNION ALL
            SELECT
            (
                SELECT companyname
                FROM tbl_CompanyContact cc
                     JOIN tbl_Portfolio p ON cc.CompanyContactID = p.TargetPortfolioID
                WHERE cc.CompanyContactID = TargetPortfolioID
                      AND p.PortfolioID = s.PortfolioID
            ) Company, 
            s.PortfolioID, 
            pfp.Date,
            CASE
                WHEN
            (
                SELECT ps.PortfolioSecurityTypeID
                FROM tbl_PortfolioShareholdingOperations s
                     JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = s.PortfolioID
                                                      AND s.SecurityID = ps.PortfolioSecurityID
                WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
            ) = 1
                THEN(pfp.AmountDueFx * -1)
                WHEN
            (
                SELECT ps.PortfolioSecurityTypeID
                FROM tbl_PortfolioShareholdingOperations s
                     JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = s.PortfolioID
                                                      AND s.SecurityID = ps.PortfolioSecurityID
                WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
            ) = 2
                THEN(pfp.AmountDueFx * -1)
                WHEN
            (
                SELECT ps.PortfolioSecurityTypeID
                FROM tbl_PortfolioShareholdingOperations s
                     JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = s.PortfolioID
                                                      AND s.SecurityID = ps.PortfolioSecurityID
                WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
            ) = 3
                THEN(pfp.AmountDueFx * -1)
                WHEN
            (
                SELECT toTypeID
                FROM tbl_PortfolioShareholdingOperations s
                     JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = s.PortfolioID
                                                      AND s.SecurityID = ps.PortfolioSecurityID
                WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
            ) = 3
                THEN(pfp.AmountDueFx * -1)
                WHEN
            (
                SELECT FromTypeID
                FROM tbl_PortfolioShareholdingOperations s
                     JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = s.PortfolioID
                                                      AND s.SecurityID = ps.PortfolioSecurityID
                WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
            ) = 3
                THEN(pfp.AmountDueFx)
            END 'Amount', 
            'FollowOnPayment', 
            2, 
            s.toTypeID, 
            s.FromTypeID
            FROM tbl_PortfolioFollowOnPayment pfp
                 INNER JOIN tbl_PortfolioShareholdingOperations s ON s.ShareholdingOperationID = pfp.ShareholdingOperationID
            WHERE s.portfolioid IN
            (
                SELECT *
                FROM @portfolios
            )
                  AND s.ToTypeID = 3
                  AND toid = @vehicleID
                  AND ISNULL(IsConditional, 0) = 0
        ) t
        WHERE 1 = CASE
                      WHEN @date IS NULL
                      THEN 1
                      WHEN Date <= @date
                      THEN 1
                      ELSE 0
                  END
        ORDER BY t.Date;
    END;
