
-- proc_FundOperationPortfolio 28,'Capital increase'            

CREATE PROC [dbo].[proc_FundOperationPortfolio]
(@fundID INT, 
 @type   VARCHAR(100)
)
AS
    BEGIN
        IF @type = '-1'
            SET @type = NULL;
        SELECT *
        FROM
        (
            SELECT sho.PortfolioID, 
                   ShareholdingOperationID AS ObjectID, 
                   'Shareholding' GridType, 
                   Date,
                   CASE
                       WHEN fromTypeID = 0
                            AND ToTypeID = 3
                       THEN 'Capital increase'
                       WHEN fromTypeID <> 0
                            AND ToTypeID = 3
                       THEN 'Investment'
                       WHEN fromTypeID = 3
                       THEN 'Divestment '
                       ELSE ''
                   END Type,
                   CASE
                       WHEN ToTypeID = 3
                       THEN CAST(Amount AS VARCHAR(MAX))
                       ELSE ''
                   END AmountOut,
                   CASE
                       WHEN fromTypeID = 3
                       THEN CAST(Amount AS VARCHAR(MAX))
                       ELSE ''
                   END AmountIn,
                   CASE
                       WHEN ToTypeID = 3
                       THEN CAST(ForeignCurrencyAmount AS VARCHAR(MAX))
                       ELSE ''
                   END ForeignCurrencyAmountOut,
                   CASE
                       WHEN fromTypeID = 3
                       THEN CAST(ForeignCurrencyAmount AS VARCHAR(MAX))
                       ELSE ''
                   END ForeignCurrencyAmountIn, 
                   sho.Notes, 
            (
                SELECT currencycode
                FROM tbl_Currency c
                     JOIN tbl_PortfolioLegal pl ON pl.CurrencyID = c.CurrencyID
                WHERE pl.PortfolioID = sho.PortfolioID
            ) CurrencyName, 
                   p.TargetPortfolioID, 
                   CompanyName
            FROM tbl_portfolioshareholdingoperations sho
                 JOIN tbl_Portfolio p ON sho.PortfolioID = p.PortfolioID
                 JOIN tbl_CompanyContact c ON c.CompanyContactID = p.TargetPortfolioID
            WHERE 1 = (CASE
                           WHEN fromTypeID = 3
                                AND fromid = @fundID
                           THEN 1
                           WHEN ToTypeID = 3
                                AND Toid = @fundID
                           THEN 1
                       END)
            UNION ALL
            SELECT p.PortfolioID, 
                   OperationID AS ObjectID, 
                   'Operation' GridType, 
                   Date, 
            (
                SELECT TypeName
                FROM tbl_PortfolioGeneralOperationType a
                WHERE a.TypeID = b.TypeID
            ) Type,
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
                   CASE
                       WHEN ToModuleID = 3
                       THEN CAST(ForeignCurrencyAmount AS VARCHAR(MAX))
                       ELSE ''
                   END ForeignCurrencyAmountOut,
                   CASE
                       WHEN FromModuleID = 3
                       THEN CAST(ForeignCurrencyAmount AS VARCHAR(MAX))
                       ELSE ''
                   END ForeignCurrencyAmountIn, 
                   Notes, 
            (
                SELECT currencycode
                FROM tbl_Currency c
                     JOIN tbl_PortfolioLegal pl ON pl.CurrencyID = c.CurrencyID
                WHERE pl.PortfolioID = b.PortfolioID
            ) CurrencyName, 
                   p.TargetPortfolioID, 
                   CompanyName
            FROM tbl_PortfolioGeneralOperation b
                 JOIN tbl_Portfolio p ON b.PortfolioID = p.PortfolioID
                 JOIN tbl_CompanyContact c ON c.CompanyContactID = p.TargetPortfolioID
            WHERE 1 = (CASE
                           WHEN FromModuleID = 3
                                AND fromid = @fundID
                           THEN 1
                           WHEN ToModuleID = 3
                                AND Toid = @fundID
                           THEN 1
                       END)
        ) t
        WHERE t.Type = ISNULL(@type, t.Type);
    END;
