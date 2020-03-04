
-- [proc_PortfolioValuation_GET]  1,1           

CREATE PROCEDURE [dbo].[proc_PortfolioValuation_GET] @ValuationID INT = NULL, 
                                                    @PortfolioID INT = NULL
AS
    BEGIN
        SELECT ValuationID, 
               PortfolioID, 
               VehicleID, 
               Date, 
               TypeID, 
               MethodID, 
               ValuationLevel, 
               InvestmentValue, 
               Discount, 
               FinalValuation, 
               Notes, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy, 
               ForeignCurrencyAmount, 
               Appliedfigures, 
               CurrentEnterpriseValue
        FROM tbl_PortfolioValuation
        WHERE ValuationID = ISNULL(@ValuationID, ValuationID)
              AND PortfolioID = @PortfolioID;
    END;  
