
--[proc_GetValuation_Report_Chart] 28,574,'31, Dec 2015'  

CREATE PROC [dbo].[proc_GetValuation_Report_Chart]
(@vehicleID INT, 
 @companyID INT, 
 @date      DATETIME
)
AS
     DECLARE @portfolioID INT;
     SET @portfolioID =
     (
         SELECT portfolioID
         FROM tbl_portfolio
         WHERE targetportfolioID = @companyID
     );
     SELECT TOP 4 pv.Date, 
                  pv.InvestmentValue
     FROM tbl_PortfolioValuation pv
     WHERE pv.vehicleid = @vehicleID
           AND portfolioid = @portfolioID
           AND DATE <= @date
     ORDER BY date DESC; 
