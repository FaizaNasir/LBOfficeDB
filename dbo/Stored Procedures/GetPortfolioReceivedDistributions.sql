CREATE PROC [dbo].[GetPortfolioReceivedDistributions]
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
            SELECT SUM(amount) Amount, 
                   SUM(ForeignCurrencyAmount) ForeignCurrencyAmount
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.PortfolioID = @portfolioid
                  AND Fromid = @vehicleID
                  AND FromTypeID = 3
                  AND date <= @date
            UNION ALL
            SELECT SUM(AmountDue), 
                   SUM(AmountDueFx)
            FROM tbl_PortfolioFollowOnPayment f
                 JOIN tbl_PortfolioShareholdingOperations sho ON sho.ShareholdingOperationID = f.ShareholdingOperationID
            WHERE sho.PortfolioID = @portfolioid
                  AND f.date <= @date
                  AND Fromid = @vehicleID
                  AND FromTypeID = 3
            UNION ALL
            SELECT SUM(amount) Amount, 
                   SUM(ForeignCurrencyAmount) ForeignCurrencyAmount
            FROM tbl_PortfolioGeneralOperation sho
            WHERE sho.PortfolioID = @portfolioid
                  AND date <= @date
                  AND sho.TypeID IN(4, 2, 3, 5)
            AND 1 = CASE
                        WHEN FromModuleID = 3
                             AND FromID = @vehicleID
                        THEN 1
                        WHEN ToModuleID = 3
                             AND ToID = @vehicleID
                        THEN 1
                    END
            UNION ALL
            SELECT-1 * SUM(amount) Amount, 
                  -1 * SUM(ForeignCurrencyAmount) ForeignCurrencyAmount
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
    END;
