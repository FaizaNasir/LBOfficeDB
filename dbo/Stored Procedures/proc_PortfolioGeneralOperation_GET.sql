CREATE PROCEDURE [dbo].[proc_PortfolioGeneralOperation_GET]
(@OperationID INT = NULL, 
 @PortfolioID INT = NULL
)
AS
    BEGIN
        SELECT OperationID, 
               PortfolioID, 
               Name, 
               TypeID, 
        (
            SELECT TOP 1 TypeName
            FROM tbl_PortfolioGeneralOperationType a
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
                   WHEN FromModuleID = 3
                   THEN CAST(Amount AS VARCHAR(MAX))
                   ELSE ''
               END AmountOut,
               CASE
                   WHEN ToModuleID = 3
                   THEN CAST(Amount AS VARCHAR(MAX))
                   ELSE ''
               END AmountIn, 
               ForeignCurrencyAmount
        FROM tbl_PortfolioGeneralOperation t
        WHERE PortfolioID = @PortfolioID
              AND OperationID = ISNULL(@OperationID, OperationID)
        ORDER BY date DESC;
    END;
