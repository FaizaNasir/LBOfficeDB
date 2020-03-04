CREATE PROC [dbo].[GetPortfolioReportDefaultFundInfo]
(@portfolioid INT, 
 @date        DATETIME, 
 @vehicleID   INT
)
AS
    BEGIN
        DECLARE @Commitment DECIMAL(18, 2);
        DECLARE @InvestedCapital DECIMAL(18, 2);
        DECLARE @Proceeds DECIMAL(18, 2);
        SELECT @Commitment = SUM(AmountWithReturn), 
               @InvestedCapital = SUM(Amount)
        FROM
        (
            SELECT SUM(amount + ISNULL(ReturnCapitalEUR, 0)) AmountWithReturn, 
                   SUM(amount) Amount
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.PortfolioID = @portfolioid
                  AND toid = @vehicleID
                  AND ToTypeID = 3
                  AND date <= @date
            UNION ALL
            SELECT SUM(CASE
                           WHEN FromTypeID = 3
                           THEN-1 * AmountDue
                           ELSE AmountDue
                       END), 
                   SUM(CASE
                           WHEN FromTypeID = 3
                           THEN-1 * AmountDue
                           ELSE AmountDue
                       END)
            FROM tbl_PortfolioFollowOnPayment f
                 JOIN tbl_PortfolioShareholdingOperations sho ON sho.ShareholdingOperationID = f.ShareholdingOperationID
            WHERE sho.PortfolioID = @portfolioid
                  AND f.date <= @date
                  AND toid = @vehicleID
                  AND ToTypeID = 3
            UNION ALL
            SELECT SUM(amount) AmountWithReturn, 
                   SUM(amount)
            FROM tbl_PortfolioGeneralOperation sho
            WHERE sho.PortfolioID = @portfolioid
                  AND date <= @date
                  AND sho.TypeID IN(1, 7, 8)
            AND 1 = CASE
                        WHEN sho.FromModuleID = 3
                             AND sho.FromID = @vehicleID
                        THEN 1
                        WHEN sho.ToModuleID = 3
                             AND sho.ToID = @vehicleID
                        THEN 1
                        ELSE 0
                    END
        ) t;
        SELECT @Proceeds = SUM(Amount)
        FROM
        (
            SELECT SUM(amount) Amount
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.PortfolioID = @portfolioid
                  AND Fromid = @vehicleID
                  AND FromTypeID = 3
                  AND date <= @date
            UNION ALL
            SELECT AmountDue
            FROM tbl_PortfolioFollowOnPayment f
                 JOIN tbl_PortfolioShareholdingOperations sho ON sho.ShareholdingOperationID = f.ShareholdingOperationID
            WHERE sho.PortfolioID = @portfolioid
                  AND f.date <= @date
                  AND Fromid = @vehicleID
                  AND FromTypeID = 3
            UNION ALL
            SELECT SUM(amount)
            FROM tbl_PortfolioGeneralOperation sho
            WHERE sho.PortfolioID = @portfolioid
                  AND date <= @date
                  AND sho.TypeID IN(2, 3, 4, 5)
            AND 1 = CASE
                        WHEN FromModuleID = 3
                             AND FromID = @vehicleID
                        THEN 1
                        WHEN ToModuleID = 3
                             AND ToID = @vehicleID
                        THEN 1
                    END
            UNION ALL
            SELECT-1 * SUM(amount)
            FROM tbl_PortfolioGeneralOperation sho
            WHERE sho.PortfolioID = @portfolioid
                  AND date <= @date
                  AND sho.TypeID IN(9, 12)
            AND 1 = CASE
                        WHEN FromModuleID = 3
                             AND FromID = @vehicleID
                        THEN 1
                        WHEN ToModuleID = 3
                             AND ToID = @vehicleID
                        THEN 1
                    END
        ) t;
        SELECT @Commitment Commitment, 
               @InvestedCapital InvestedCapital, 
               @Proceeds Proceeds;
    END;
