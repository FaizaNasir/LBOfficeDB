
-- [proc_PortfolioValuationSecurityDetails_GET] 20,1    

CREATE PROCEDURE [dbo].[proc_PortfolioValuationSecurityDetails_GET]
(@PortfolioID INT = NULL, 
 @valuationID INT
)
AS
    BEGIN
        SELECT s.PortfolioSecurityID, 
               s.Name, 
               v.Stock, 
               (CONVERT(VARCHAR(20), v.Value)) Value, 
        (
            SELECT PortfolioSecurityTypeName
            FROM tbl_PortfolioSecurityType a
            WHERE a.PortfolioSecurityTypeID = s.PortfolioSecurityTypeID
        ) PortfolioSecurityTypeName
        FROM tbl_PortfolioSecurity s
             JOIN tbl_PortfolioValuationDetails v ON v.SecurityID = s.PortfolioSecurityID
        WHERE s.PortfolioID = @PortfolioID
              AND v.valuationID = @valuationID;
    END;
