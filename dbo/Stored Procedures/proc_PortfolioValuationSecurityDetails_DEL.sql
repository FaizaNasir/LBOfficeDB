
-- [proc_PortfolioValuationSecurityDetails_GET] 20,1    

CREATE PROCEDURE [dbo].[proc_PortfolioValuationSecurityDetails_DEL](@ValuationID INT)
AS
    BEGIN
        DELETE FROM tbl_PortfolioValuationDetails
        WHERE ValuationID = @ValuationID;
        SELECT 1 Result;
    END;
