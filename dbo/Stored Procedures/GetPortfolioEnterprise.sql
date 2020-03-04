CREATE PROC [dbo].[GetPortfolioEnterprise]
(@portfolioid           INT, 
 @PortfolioEnterpriseID INT
)
AS
    BEGIN
        SELECT PortfolioEnterpriseID, 
               PortfolioID, 
               Date, 
               CurrencyCode, 
               EnterpriseValue, 
               NetFinancialDebt, 
               EquityValue, 
               Notes, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy, 
               EnterpriseValueEur, 
               NetFinancialDebtEur, 
               EquityValueEur
        FROM tbl_PortfolioEnterprise
        WHERE portfolioid = @portfolioid
              AND PortfolioEnterpriseID = ISNULL(@PortfolioEnterpriseID, PortfolioEnterpriseID)
        ORDER BY date DESC;
    END;
