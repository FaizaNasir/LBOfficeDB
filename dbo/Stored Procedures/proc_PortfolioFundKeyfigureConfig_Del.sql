CREATE PROCEDURE [dbo].[proc_PortfolioFundKeyfigureConfig_Del] @ID INT
AS
     DELETE FROM tbl_PortfolioFundKeyfigureConfig
     WHERE PortfolioFundKeyfigureConfigID = @ID;
     DELETE FROM tbl_PortfolioFundKeyFIgure
     WHERE PortfolioFundKeyfigureConfigID = @ID;
     SELECT 1;
