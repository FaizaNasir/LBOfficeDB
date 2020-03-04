CREATE PROCEDURE [dbo].[proc_PortfolioValuation_DEL] @ValuationID INT
AS
    BEGIN
        DELETE FROM tbl_PortfolioValuation
        WHERE ValuationID = @ValuationID;
        DELETE FROM tbl_PortfolioValuationDetails
        WHERE ValuationID = @ValuationID;
        SELECT 1 Result;
    END;
