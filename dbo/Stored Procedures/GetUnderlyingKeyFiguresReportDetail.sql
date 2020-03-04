CREATE PROC [dbo].[GetUnderlyingKeyFiguresReportDetail]
AS
     SELECT a.PortfolioFundKeyFIgureID, 
            a.PortfolioFundUnderlyingInvestmentsID, 
            a.Amount, 
            b.Name, 
            YEAR(a.Year) Year, 
            Seq
     FROM tbl_PortfolioFundKeyFigure a
          JOIN tbl_PortfolioFundKeyFigureConfig b ON a.PortfolioFundKeyfigureConfigID = b.PortfolioFundKeyfigureConfigID
     WHERE a.year IS NOT NULL
     ORDER BY b.Seq, 
              YEAR(a.Year) DESC;
