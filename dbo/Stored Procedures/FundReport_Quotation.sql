
-- FundReport_Quotation 8,'12-31-2016',1

CREATE PROC [dbo].[FundReport_Quotation]
(@fundID      INT, 
 @date        DATETIME, 
 @QuotationID INT
)
AS
     DECLARE @lastValuation TABLE
     (PortfolioID INT, 
      CompanyName VARCHAR(1000), 
      Valuation   DECIMAL(18, 6), 
      Quotation   VARCHAR(100)
     );
     SET @fundID = 8;
     SET @date = '12/31/2016';
     INSERT INTO @lastValuation
            SELECT p.PortfolioID, 
                   cc.CompanyName, 
                   ISNULL(
            (
                SELECT TOP 1 FinalValuation
                FROM tbl_PortfolioValuation pval
                WHERE pval.portfolioid = p.portfolioid
                      AND pval.vehicleid = pv.vehicleID
                      AND date <= @date
                ORDER BY date DESC
            ), 0) Valuation,
                   CASE
                       WHEN e.QuotationID = 1
                       THEN 'Non Quoted'
                       WHEN e.QuotationID IN(2, 3)
                       THEN 'Quoted'
                       WHEN e.QuotationID = 4
                       THEN 'OPCVM'
                   END Quotation
            FROM tbl_portfolio p
                 JOIN tbl_portfoliovehicle pv ON pv.portfolioid = p.portfolioid
                 JOIN tbl_eligibility e ON e.moduleid = 7
                                           AND e.objectmoduleid = p.portfolioid
                                           AND e.vehicleid = pv.vehicleid
                 JOIN tbl_companycontact cc ON cc.companycontactid = p.targetportfolioid
            WHERE pv.vehicleid = @fundID
                  AND 1 = CASE
                              WHEN @QuotationID = 2
                                   AND e.QuotationID IN(2, 3)
                              THEN 1
                              WHEN @QuotationID = e.QuotationID
                              THEN 1
                          END
            ORDER BY e.QuotationID, 
                     cc.CompanyName;
     SELECT *
     FROM @lastValuation;
