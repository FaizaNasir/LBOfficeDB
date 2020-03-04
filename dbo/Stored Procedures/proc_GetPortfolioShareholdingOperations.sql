CREATE PROC [dbo].[proc_GetPortfolioShareholdingOperations]
(@PortfolioID   INT, 
 @year          INT, 
 @TypeID        INT, 
 @ShareHolderID INT
)
AS
     IF @year = -1
         SET @year = NULL;
     IF @TypeID IS NULL
         SET @TypeID = 0;
     IF @ShareHolderID = -1
         SET @ShareHolderID = NULL;
     SELECT ShareholdingOperationID, 
            sho.Name, 
            sho.FromID, 
            sho.ToID, 
            sho.ForeignCurrencyAmount, 
            sho.Amount, 
            FromTypeID,
            CASE
                WHEN fromtypeid = 3
                THEN dbo.[F_GetObjectModuleName_V1](FromID, FromTypeID, 1)
                WHEN ToTypeID = 3
                THEN dbo.[F_GetObjectModuleName_V1](ToID, ToTypeID, 0)
            END FundName,
            CASE
                WHEN fromtypeid = 3
                THEN
     (
         SELECT TOP 1 VehicleID
         FROM tbl_Vehicle
         WHERE VehicleID = FromID
     )
                WHEN ToTypeID = 3
                THEN
     (
         SELECT TOP 1 VehicleID
         FROM tbl_Vehicle
         WHERE VehicleID = ToID
     )
            END FundId, 
            dbo.[F_GetObjectModuleName_V1](FromID, FromTypeID, 1) FromName, 
            ToTypeID, 
            dbo.[F_GetObjectModuleName_V1](ToID, ToTypeID, 0) ToName, 
            Date,
            CASE
                WHEN FromID = -1
                     AND FromTypeID = 0
                     AND (ps.PortfolioSecurityTypeID = 1
                          OR ps.PortfolioSecurityTypeID = 3
                          OR ps.PortfolioSecurityTypeID = 4)
                THEN 'Capital increase'
                WHEN FromTypeID <> 0
                     AND FromTypeID = 3
                THEN 'Divestment'
                WHEN ToTypeID = 3
                THEN 'Investment'
                WHEN FromID = -1
                     AND FromTypeID = 0
                THEN 'Investment'
                WHEN ToID = -2
                THEN 'Divestment'
            END Type,
            CASE
                WHEN ToTypeID = 3
                THEN CAST(Amount AS VARCHAR(MAX))
                WHEN FromTypeID = 0
                     AND totypeid IN(4, 5)
                THEN CAST(Amount AS VARCHAR(MAX))
                ELSE ''
            END AmountOut,
            CASE
                WHEN FromTypeID = 3
                THEN CAST(Amount AS VARCHAR(MAX))
                WHEN FromTypeID IN(4, 5)
                     AND ToTypeID = 0
                THEN CAST(Amount AS VARCHAR(MAX))
                ELSE ''
            END AmountIn, 
            SecurityID, 
            Number, 
            sho.Notes, 
            ps.Name SecurityName, 
            ps.PortfolioSecurityTypeID, 
            ps.PortfolioSecurityID, 
            PortfolioSecurityTypeName, 
            isConditional, 
     (
         SELECT currencycode
         FROM tbl_Currency c
              JOIN tbl_PortfolioLegal pl ON pl.CurrencyID = c.CurrencyID
         WHERE pl.PortfolioID = sho.PortfolioID
     ) CurrencyName, 
            isConversion
     FROM tbl_PortfolioShareholdingOperations sho
          JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = sho.PortfolioID
                                           AND sho.SecurityID = ps.PortfolioSecurityID
          JOIN tbl_PortfolioSecurityType pst ON pst.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
     WHERE sho.portfolioid = @portfolioid
           AND YEAR(date) = ISNULL(@year, YEAR(date))
           AND 1 = CASE
                       WHEN @TypeID = 0
                       THEN 1
                       WHEN @TypeID = 1
                            AND FromTypeID = 0
                            AND ToTypeID = 3
                       THEN 1
                       WHEN @TypeID = 2
                            AND FromTypeID <> 0
                            AND FromTypeID = 3
                       THEN 1
                       WHEN @TypeID = 3
                            AND FromTypeID = 3
                            AND (ToTypeID <> 0
                                 OR ToTypeID = 0)
                       THEN 1
                   END
     ORDER BY DATE DESC;
