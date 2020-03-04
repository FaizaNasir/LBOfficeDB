CREATE PROCEDURE [dbo].[proc_PortfolioPerformanceForeignCurrencyGet] @portfolioID  INT      = NULL, 
                                                                     @targetID     INT, 
                                                                     @targetTypeID INT, 
                                                                     @teamMemberID INT, 
                                                                     @date         DATETIME
AS
    BEGIN
        IF @teamMemberID = '0'
            SET @teamMemberID = NULL;
        SET @date = CAST(CONVERT(VARCHAR(10), @date, 101) + ' 23:59:59' AS DATETIME);
        IF @date IS NULL
            SET @date = GETDATE();
        DECLARE @tblvaluation TABLE
        (date   DATETIME, 
         Amount DECIMAL(18, 2), 
         Type   VARCHAR(100)
        );
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_portfolio p
                 JOIN tbl_portfoliovehicle pv ON p.PortfolioID = pv.PortfolioID
            WHERE pv.portfolioid = @portfolioID
                  AND pv.VehicleID = @targetID
                  AND pv.[Status] IN(1, 2, 4)
        )
            BEGIN
                INSERT INTO @tblvaluation
                       SELECT TOP 1 Date, 
                                    pv.InvestmentValue - (ISNULL(Discount, 0) * pv.InvestmentValue) / 100, 
                                    'Valuation'
                       FROM tbl_PortfolioValuation pv
                       WHERE portfolioid = @portfolioID
                             AND VehicleID = @targetID
                             AND Date <= @date
                       ORDER BY Date DESC;
        END;
        UPDATE @tblvaluation
          SET 
              date = @date
        WHERE date <= @date;
        SELECT 1 IsInclude, 
               *,
               CASE
                   WHEN OperationTypeID = 0
                        AND FromTypeID = 0
                        AND (PortfolioSecurityTypeID = 1
                             OR PortfolioSecurityTypeID = 3
                             OR PortfolioSecurityTypeID = 4)
                   THEN 'Capital increase'
                   WHEN OperationTypeID = 0
                        AND ToTypeID = 3
                   THEN 'Investment'
                   WHEN OperationTypeID = 0
                        AND FromTypeID <> 0
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
            SELECT Date, 
                   ISNULL(foreigncurrencyamount, s.Amount) Amount, 
                   'ShareholdingOperations' AS Category, 
                   0 OperationTypeID, 
                   toTypeID, 
                   FromTypeID, 
                   ps.PortfolioSecurityTypeID
            FROM tbl_PortfolioShareholdingOperations s
                 JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = s.PortfolioID
                                                  AND s.SecurityID = ps.PortfolioSecurityID
            WHERE toTypeID = @targetTypeID
                  AND toid = @targetID
                  AND s.portfolioid = @portfolioID
                  AND ISNULL(isConditional, 0) = 0
            UNION ALL
            SELECT date, 
                   ISNULL(foreigncurrencyamount, s.Amount), 
                   'GeneralOperation', 
                   TypeID, 
                   ToModuleID, 
                   FromModuleID, 
                   0
            FROM tbl_PortfolioGeneralOperation s
            WHERE fromModuleID = @targetTypeID
                  AND fromid = @targetID
                  AND portfolioid = @portfolioID
                  AND ISNULL(isConditional, 0) = 0
            UNION ALL
            SELECT date, 
                   ISNULL(foreigncurrencyamount, s.amount), 
                   'ShareholdingOperations', 
                   0, 
                   toTypeID, 
                   FromTypeID, 
                   ps.PortfolioSecurityTypeID
            FROM tbl_PortfolioShareholdingOperations s
                 JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = s.PortfolioID
                                                  AND s.SecurityID = ps.PortfolioSecurityID
            WHERE fromTypeID = @targetTypeID
                  AND fromid = @targetID
                  AND s.portfolioid = @portfolioID
                  AND ISNULL(isConditional, 0) = 0
            UNION ALL
            SELECT date, 
                   ISNULL(foreigncurrencyamount, s.amount), 
                   'GeneralOperation', 
                   TypeID, 
                   ToModuleID, 
                   FromModuleID, 
                   0
            FROM tbl_PortfolioGeneralOperation s
            WHERE toModuleID = @targetTypeID
                  AND toid = @targetID
                  AND portfolioid = @portfolioID
                  AND ISNULL(isConditional, 0) = 0
            UNION ALL
            SELECT *, 
                   0, 
                   0, 
                   0, 
                   0
            FROM @tblvaluation
            UNION ALL
            SELECT pfp.Date, 
                   pfp.AmountDueFX Amount, 
                   'FollowOnPayment', 
                   0, 
                   s.toTypeID, 
                   s.FromTypeID, 
                   0
            FROM tbl_PortfolioFollowOnPayment pfp
                 INNER JOIN tbl_PortfolioShareholdingOperations s ON s.ShareholdingOperationID = pfp.ShareholdingOperationID
            WHERE s.portfolioid = @portfolioID
                  AND toTypeID = @targetTypeID
                  AND toid = @targetID
                  AND ISNULL(s.isConditional, 0) = 0
        ) t
        WHERE 1 = CASE
                      WHEN @date IS NULL
                      THEN 1
                      WHEN Date <= CAST(@date AS DATETIME)
                      THEN 1
                      ELSE 0
                  END;
    END;
