CREATE PROCEDURE [dbo].[proc_PortfolioValuationGrid]
(@PortfolioID INT = NULL, 
 @vehicleID   INT = NULL
)
AS
    BEGIN
        SELECT ValuationID, 
               PortfolioID, 
               VehicleID, 
               Date, 
               TypeID, 
        (
            SELECT TOP 1 ValuationTypeName
            FROM tbl_PortfolioValuationType b
            WHERE a.TypeID = b.ValuationTypeID
        ) TypeName, 
               MethodID, 
        (
            SELECT TOP 1 ValuationMethodName
            FROM tbl_PortfolioValuationMethod b
            WHERE a.MethodID = b.ValuationMethodID
        ) MethodName, 
               ValuationLevel,
               CASE
                   WHEN a.Discount <> 0
                   THEN a.FinalValuation
                   ELSE a.InvestmentValue
               END AS 'InvestmentValue', 
               Discount, 
               FinalValuation, 
        (
            SELECT CURRENCYCODE
            FROM tbl_PortfolioLegal AA
                 JOIN tbl_Currency B ON AA.CurrencyID = B.CurrencyID
                                        AND AA.PortfolioID = A.PortfolioID
        ) Currency, 
               Notes, 
               Appliedfigures, 
               CurrentEnterpriseValue
        FROM tbl_PortfolioValuation a
        WHERE PortfolioID = @PortfolioID
              AND VehicleID = @vehicleID
        ORDER BY Date DESC;
    END;