CREATE PROCEDURE [dbo].[proc_Fund_Strategy_PortfolioSize_GET] @FundID INT = NULL
AS
    BEGIN
        SELECT FundStrategyPortfolioSizeID, 
               ForecastFrom, 
               ForecastTo, 
               InvestmentFrom, 
               InvertmentTo, 
               CreatedDateTime, 
               ModifiedDateTime, 
               FundID, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_FundStrategyPortfolioSize
        WHERE FundID = ISNULL(@FundID, FundID);
    END;
