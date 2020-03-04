
CREATE PROCEDURE [dbo].[proc_Portfolio_Legal_GET]   --52,28                

(@PortfolioID INT = NULL, 
 @vehicleID   INT = NULL
)
AS
    BEGIN
        DECLARE @CapitalCalculation DECIMAL(18, 2)= NULL;
        SET @CapitalCalculation = (
        (
            SELECT SUM(psho.Number)
            FROM tbl_PortfolioShareholdingOperations psho
            WHERE psho.FromID = -1
                  AND psho.PortfolioID = @PortfolioID
        ) *
        (
            SELECT TOP 1 ps.NominalValue
            FROM tbl_PortfolioShareholdingOperations psho
                 LEFT OUTER JOIN tbl_PortfolioSecurity ps ON psho.SecurityID = ps.PortfolioSecurityID
                                                             AND ps.PortfolioID = psho.PortfolioID
            WHERE psho.FromID = -1
                  AND psho.PortfolioID = @PortfolioID
        ));
        SELECT DISTINCT 
               pl.PortfolioLegalID, 
               pl.Capital,

               --(
               --    SELECT @CapitalCalculation
               --) AS 'Capital', 
               pl.CapitalCurrencyID, 
               pl.LegalStructureID, 
               pl.LegalRepresentativeCompanyID, 
               pl.TradeRegister, 
               pl.SectorCode, 
               pl.CurrencyID, 
               pl.IsQuoted, 
               pl.StockExchange, 
               pl.TickerSymbol, 
               pl.ContingentLiabilities, 
               pl.LegalNotes, 
               cc.CompanyName, 
               pc.CurrencyCode AS 'LegalCurrency', 
               cac.CurrencyCode AS 'CapitalCurrency', 
               LegalStructureID 'LegalstructureName', 
               NumberOfShares, 
               NumberOfShares / (CASE
                                     WHEN ISNULL(dbo.[F_NonDiluted](@vehicleID, 3, GETDATE(), pl.PortfolioID), 0) != 0
                                     THEN dbo.[F_NonDiluted](@vehicleID, 3, GETDATE(), pl.PortfolioID)
                                     ELSE 1
                                 END) RateOfDetention
        FROM tbl_PortfolioLegal pl
             LEFT OUTER JOIN tbl_PortfolioLegalContactIndividual plci ON pl.PortfolioLegalID = plci.PortfolioLegalID
             LEFT OUTER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = pl.LegalRepresentativeCompanyID
             LEFT OUTER JOIN tbl_Currency pc ON pc.CurrencyID = pl.CurrencyID
             LEFT OUTER JOIN tbl_Currency cac ON cac.CurrencyID = pl.CapitalCurrencyID

        --LEFT OUTER JOIN tbl_PortfolioLegalStructure pls ON pls.LegalStructureID = pl.LegalStructureID  

        WHERE PortfolioID = ISNULL(@PortfolioID, PortfolioID);
    END;
