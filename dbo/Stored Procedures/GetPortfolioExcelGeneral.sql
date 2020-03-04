CREATE PROC [dbo].[GetPortfolioExcelGeneral]
(@portfolioID INT, 
 @date        DATETIME
)
AS
    BEGIN
        SELECT *,
               CASE
                   WHEN ForeignCurrencyAmount IS NOT NULL
                   THEN ForeignCurrencyAmount / Amount
                   WHEN ForeignCurrencyAmountReturnOfCap IS NOT NULL
                   THEN ForeignCurrencyAmountReturnOfCap / AmountReturnOfCap
                   WHEN ProfitFx IS NOT NULL
                   THEN ProfitFx / Profit
                   WHEN FeesFx IS NOT NULL
                   THEN FeesFx / Fees
                   WHEN InterestFx IS NOT NULL
                   THEN InterestFx / Interest
                   WHEN HedgingFx IS NOT NULL
                   THEN HedgingFx / Hedging
               END Rate
        FROM
        (
            SELECT CASE
                       WHEN FromTypeID = 3
                       THEN FromID
                       WHEN ToTypeID = 3
                       THEN ToID
                   END VehicleID, 
                   Date,
                   CASE
                       WHEN ToTypeID = 3
                       THEN Amount
                   END Amount,
                   CASE
                       WHEN ToTypeID = 3
                       THEN ForeignCurrencyAmount
                   END ForeignCurrencyAmount,
                   CASE
                       WHEN FromTypeID = 3
                       THEN sho.ReturnCapitalEUR
                   END AmountReturnOfCap,
                   CASE
                       WHEN FromTypeID = 3
                       THEN sho.ReturnCapitalFx
                   END ForeignCurrencyAmountReturnOfCap,
                   CASE
                       WHEN FromTypeID = 3
                       THEN Amount - sho.ReturnCapitalEUR
                   END Profit,
                   CASE
                       WHEN FromTypeID = 3
                       THEN ForeignCurrencyAmount - sho.ReturnCapitalFx
                   END ProfitFx, 
                   NULL Fees, 
                   NULL FeesFx, 
                   NULL Interest, 
                   NULL InterestFx, 
                   NULL Hedging, 
                   NULL HedgingFx,
                   CASE
                       WHEN FromTypeID = 3
                       THEN dbo.F_GetObjectName(3, FromID)
                       WHEN ToTypeID = 3
                       THEN dbo.F_GetObjectName(3, ToID)
                   END VehicleName
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.portfolioid = @portfolioID
            UNION ALL
            SELECT CASE
                       WHEN FromTypeID = 3
                       THEN FromID
                       WHEN ToTypeID = 3
                       THEN ToID
                   END VehicleID, 
                   f.Date,
                   CASE
                       WHEN ToTypeID = 3
                       THEN AmountDue
                   END AmountDue,
                   CASE
                       WHEN ToTypeID = 3
                       THEN AmountDueFx
                   END AmountDueFx, 
                   NULL AmountReturnOfCap, 
                   NULL ForeignCurrencyAmountReturnOfCap, 
                   NULL Profit, 
                   NULL ProfitFx, 
                   NULL Fees, 
                   NULL FeesFx, 
                   NULL Interest, 
                   NULL InterestFx, 
                   NULL Hedging, 
                   NULL HedgingFx,
                   CASE
                       WHEN FromTypeID = 3
                       THEN dbo.F_GetObjectName(3, FromID)
                       WHEN ToTypeID = 3
                       THEN dbo.F_GetObjectName(3, ToID)
                   END VehicleName
            FROM tbl_PortfolioFollowOnPayment f
                 JOIN tbl_PortfolioShareholdingOperations sho ON sho.ShareholdingOperationID = f.ShareholdingOperationID
            WHERE sho.portfolioid = @portfolioID
            UNION ALL
            SELECT CASE
                       WHEN FromModuleID = 3
                       THEN FromID
                       WHEN ToModuleID = 3
                       THEN ToID
                   END VehicleID, 
                   Date, 
                   NULL, 
                   NULL, 
                   NULL AmountReturnOfCap, 
                   NULL ForeignCurrencyAmountReturnOfCap, 
                   NULL Profit, 
                   NULL ProfitFx,
                   CASE
                       WHEN TypeID IN(1, 3, 7)
                       THEN Amount
                   END Fees,
                   CASE
                       WHEN TypeID IN(1, 3, 7)
                       THEN ForeignCurrencyAmount
                   END FeesFx,
                   CASE
                       WHEN TypeID IN(4, 5, 6)
                       THEN Amount
                   END Interest,
                   CASE
                       WHEN TypeID IN(4, 5, 6)
                       THEN ForeignCurrencyAmount
                   END InterestFx,
                   CASE
                       WHEN TypeID = 2
                       THEN Amount
                       WHEN TypeID = 12
                       THEN-1 * Amount
                   END Hedging,
                   CASE
                       WHEN TypeID = 2
                       THEN ForeignCurrencyAmount
                       WHEN TypeID = 12
                       THEN-1 * ForeignCurrencyAmount
                   END HedgingFx,
                   CASE
                       WHEN FromModuleID = 3
                       THEN dbo.F_GetObjectName(3, FromID)
                       WHEN ToModuleID = 3
                       THEN dbo.F_GetObjectName(3, ToID)
                   END VehicleName
            FROM tbl_PortfolioGeneralOperation pgo
            WHERE pgo.PortfolioID = @portfolioID
                  AND TypeID NOT IN(8, 9)
        ) t
        WHERE VehicleID IS NOT NULL
              AND t.Date <= @date
        ORDER BY t.date DESC;
    END;
