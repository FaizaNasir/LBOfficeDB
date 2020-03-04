-- FundReport_OPCVM 8,'12-31-2016'

CREATE PROC [dbo].[FundReport_OPCVM]
(@fundID INT, 
 @date   DATETIME
)
AS
     DECLARE @lastValuation TABLE
     (PortfolioID  INT, 
      SecurityName VARCHAR(1000), 
      Valuation    DECIMAL(18, 6), 
      Quotation    VARCHAR(100)
     );
     SET @fundID = 8;
     SET @date = '12/31/2016';
     INSERT INTO @lastValuation
            SELECT p.PortfolioID, 
                   ps.Name SecurityName, 
                   ISNULL(
            (
                SELECT TOP 1 Stock * Value
                FROM tbl_PortfolioValuation pval
                     JOIN tbl_PortfolioValuationdetails pvald ON pvald.ValuationID = pval.ValuationID
                WHERE pval.portfolioid = p.portfolioid
                      AND pval.vehicleid = pv.vehicleID
                      AND pvald.SecurityID = ps.PortfolioSecurityID
                      AND date <= @date
                ORDER BY date DESC
            ), 0) Valuation, 
                   'OPCVM' Quotation
            FROM tbl_portfolio p
                 JOIN tbl_portfoliovehicle pv ON pv.portfolioid = p.portfolioid
                 JOIN tbl_eligibility e ON e.moduleid = 7
                                           AND e.objectmoduleid = p.portfolioid
                                           AND e.vehicleid = pv.vehicleid
                 JOIN tbl_companycontact cc ON cc.companycontactid = p.targetportfolioid
                 JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = p.PortfolioID
            WHERE pv.vehicleid = @fundID
                  AND e.QuotationID = 4
            ORDER BY SecurityName;
     SELECT *
     FROM @lastValuation
     WHERE valuation > 0;
