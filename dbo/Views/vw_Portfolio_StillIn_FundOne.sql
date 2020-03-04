CREATE VIEW [dbo].[vw_Portfolio_StillIn_FundOne]
AS
     SELECT TOP (100) PERCENT p.PortfolioID, 
                              c.CompanyContactID, 
                              c.CompanyName AS 'ComapanyName', 
                              b.BusinessAreaTitle AS 'Sector', 
     (
         SELECT TOP (1) Date
         FROM dbo.tbl_PortfolioShareholdingOperations AS pso
         WHERE(ToID = '28')
              AND (PortfolioID = p.PortfolioID)
              AND (ToTypeID = 3)
         ORDER BY Date
     ) AS 'InvestmentDate', 
     (
         SELECT TOP (1) InvestmentValue
         FROM dbo.tbl_PortfolioValuation AS pso
         WHERE(PortfolioID = p.PortfolioID)
              AND (VehicleID = pv.VehicleID)
         ORDER BY Date DESC
     ) AS 'InvestmentValue', 
                              dbo.F_NonDiluted(pv.VehicleID, 3, GETDATE(), p.PortfolioID) AS 'Owned', 
                              pv.Amount AS 'AmountInvested', 
                              CAST(pv.Amount * 100.0 /
     (
         SELECT SUM(Amount) AS Expr1
         FROM dbo.tbl_PortfolioVehicle AS cc
         WHERE(VehicleID = '28')
     ) AS DECIMAL(18, 2)) AS 'PortfolioWeight', 
                              c.CompanyBusinessDesc AS 'CompanyComments'
     FROM dbo.tbl_PortfolioVehicle AS pv
          INNER JOIN dbo.tbl_Portfolio AS p ON pv.PortfolioID = p.PortfolioID
          INNER JOIN dbo.tbl_CompanyContact AS c ON c.CompanyContactID = p.TargetPortfolioID
          LEFT OUTER JOIN dbo.tbl_BusinessArea AS b ON c.CompanyBusinessAreaID = b.BusinessAreaID
     WHERE(pv.VehicleID = '28')
          AND (pv.STATUS = 1)
     ORDER BY 'ComapanyName';
