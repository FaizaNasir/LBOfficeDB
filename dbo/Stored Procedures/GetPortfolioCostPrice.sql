CREATE PROC [dbo].[GetPortfolioCostPrice]
(@portfolioid INT, 
 @vehicleID   INT, 
 @date        DATETIME
)
AS
    BEGIN
        SELECT SUM(amount) Amount, 
               SUM(ForeignCurrencyAmount) ForeignCurrencyAmount
        FROM
        (
            SELECT SUM(amount) + CAST(ISNULL(
            (
                SELECT TOP 1 CASE
                                 WHEN
                (
                    SELECT FromTypeID
                    FROM tbl_PortfolioShareholdingOperations s
                    WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
                ) = 3
                                 THEN ISNULL(SUM(pfp.AmountDue * -1), 0)
                                 ELSE ISNULL(SUM(pfp.AmountDue), 0)
                             END
                FROM tbl_PortfolioFollowOnPayment pfp
                     INNER JOIN tbl_PortfolioShareholdingOperations pso ON pso.ShareholdingOperationID = pfp.ShareholdingOperationID
                WHERE pso.PortfolioID = @portfolioid
                      AND ISNULL(isConditional, 0) = 0
                      AND ToTypeID = 3
                      AND ToID = @vehicleID
                      AND pso.Date <= @date
                      AND pfp.Date <= @date
                GROUP BY pfp.ShareholdingOperationID
            ), 0) AS DECIMAL(18, 2)) Amount, 
                   SUM(ForeignCurrencyAmount) + CAST(ISNULL(
            (
                SELECT TOP 1 CASE
                                 WHEN
                (
                    SELECT FromTypeID
                    FROM tbl_PortfolioShareholdingOperations s
                    WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
                ) = 3
                                 THEN ISNULL(SUM(pfp.AmountDueFx * -1), 0)
                                 ELSE ISNULL(SUM(pfp.AmountDueFx), 0)
                             END
                FROM tbl_PortfolioFollowOnPayment pfp
                     INNER JOIN tbl_PortfolioShareholdingOperations pso ON pso.ShareholdingOperationID = pfp.ShareholdingOperationID
                WHERE pso.PortfolioID = @portfolioid
                      AND ISNULL(isConditional, 0) = 0
                      AND ToTypeID = 3
                      AND ToID = @vehicleID
                      AND pso.Date <= @date
                      AND pfp.Date <= @date
                GROUP BY pfp.ShareholdingOperationID
            ), 0) AS DECIMAL(18, 2)) ForeignCurrencyAmount
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.PortfolioID = @portfolioid
                  AND toid = @vehicleID
                  AND ToTypeID = 3
                  AND date <= @date
            UNION ALL
            SELECT SUM(amount) Amount, 
                   SUM(ForeignCurrencyAmount) ForeignCurrencyAmount
            FROM tbl_PortfolioGeneralOperation sho
            WHERE sho.PortfolioID = @portfolioid
                  AND date <= @date
                  AND 1 = CASE
                              WHEN sho.FromModuleID = 3
                                   AND sho.FromID = @vehicleID
                              THEN 1
                              WHEN sho.ToModuleID = 3
                                   AND sho.ToID = @vehicleID
                              THEN 1
                              ELSE 0
                          END
                  AND sho.TypeID IN(1, 7, 8)
        ) t;
    END;
