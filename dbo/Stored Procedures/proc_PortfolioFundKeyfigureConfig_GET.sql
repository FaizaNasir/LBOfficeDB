CREATE PROCEDURE [dbo].[proc_PortfolioFundKeyfigureConfig_GET]-- 1           
@PortfolioFundUnderlyingInvestmentsID INT      = NULL, 
@date                                 DATETIME
AS
    BEGIN
        SELECT PortfolioFundKeyfigureConfigID, 
               PortfolioFundUnderlyingInvestmentsID, 
               Name, 
               Seq, 
               ISNULL(IsReport, 0) AS 'IsReport', 
               ISNULL(IsChart, 0) AS 'IsChart', 
               SubTab, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy, 
               Date
        FROM tbl_PortfolioFundKeyfigureConfig
        WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
        --AND date = isnull(@date,
        --                 (
        --                     SELECT TOP 1 date
        --                     FROM tbl_PortfolioFundKeyfigureConfig
        --                     WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
        --                     ORDER BY date DESC
        --                 ))
        ORDER BY seq;
    END;
