
-- created by : Syed Zain ALi   
-- [proc_PortfolioFundUserGet] 1,1,4   

CREATE PROCEDURE [dbo].[proc_PortfolioFundUserGet] @portfolioID INT = NULL, 
                                                   @userID      INT
AS
    BEGIN
        SELECT PortfolioFundUserID, 
               PortfolioID, 
               FundID, 
               UserID
        FROM tbl_portfoliofunduser
        WHERE PortfolioID = @portfolioID
              AND UserID = @userID;
    END;
