CREATE PROCEDURE [dbo].[proc_PortfolioFundGeneralOperation_GET]
(@OperationID INT = NULL, 
 @vehicleID   INT = NULL
)
AS
    BEGIN
        SELECT OperationID, 
               VehicleID, 
               Name, 
               TypeID, 
        (
            SELECT TOP 1 TypeName
            FROM tbl_PortfolioFundGeneralOperationType a
            WHERE a.Typeid = t.typeid
        ) TypeName, 
               Date, 
               Amount, 
               CurrencyID, 
        (
            SELECT CurrencyCode
            FROM tbl_currency c
            WHERE c.CurrencyID = t.CurrencyID
        ) CurrencyName, 
               FromID, 
               ToID, 
               FromModuleID, 
               dbo.[F_GetObjectName](ToModuleID, ToID) ToName, 
               dbo.[F_GetObjectName](FromModuleID, FromID) FromName, 
               dbo.[F_GetObjectName]
        (3,
         CASE
             WHEN ToModuleID = 3
             THEN ToID
             WHEN FromModuleID = 3
             THEN FromID
         END
        ) FundName, 
               ToModuleID, 
               DocumentID, 
               Notes, 
               IsConditional, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy,
               CASE
                   WHEN FromModuleID = 0
                        AND ToModuleID = 3
                   THEN 'Capital increase'
                   WHEN FromModuleID <> 0
                        AND FromModuleID = 3
                   THEN 'Investment'
                   WHEN FromModuleID = 3
                        AND ToModuleID <> 0
                   THEN 'Divestment '
                   ELSE ''
               END Type,
               CASE
                   WHEN TypeID = 2
                        OR (TypeID = 4
                            AND ToID = t.VehicleID)
                   THEN CAST(Amount AS VARCHAR(MAX))
                   ELSE ''
               END AmountOut,
               CASE
                   WHEN TypeID = 3
                        OR (TypeID = 4
                            AND FromID = t.VehicleID)
                   THEN CAST(Amount AS VARCHAR(MAX))
                   ELSE ''
               END AmountIn,
               CASE
                   WHEN TypeID = 1
                   THEN CAST(Amount AS VARCHAR(MAX))
                   ELSE ''
               END AmountOther,
               CASE
                   WHEN TypeID = 2
                        OR (TypeID = 4
                            AND ToID = t.VehicleID)
                   THEN CAST(ForeignCurrencyAmount AS VARCHAR(MAX))
                   ELSE ''
               END ForeignCurrencyAmountOut,
               CASE
                   WHEN TypeID = 3
                        OR (TypeID = 4
                            AND FromID = t.VehicleID)
                   THEN CAST(ForeignCurrencyAmount AS VARCHAR(MAX))
                   ELSE ''
               END ForeignCurrencyAmountIn,
               CASE
                   WHEN TypeID = 1
                   THEN CAST(ForeignCurrencyAmount AS VARCHAR(MAX))
                   ELSE ''
               END ForeignCurrencyAmountOther, 
               ForeignCurrencyAmount, 
               t.Investment_ReturnOfCapital, 
               t.FeeOther_Profits, 
               t.FeeOther_Profits_FX, 
               t.Investment_ReturnOfCapital_FX, 
               t.IncludingRecallableDistribution, 
               t.IncludingRecallableDistribution_FX
        FROM tbl_PortfolioFundGeneralOperation t
        WHERE VehicleID = @vehicleID
              AND OperationID = ISNULL(@OperationID, OperationID)
        ORDER BY date DESC;
    END;
