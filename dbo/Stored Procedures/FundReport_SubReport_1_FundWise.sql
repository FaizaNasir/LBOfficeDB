-- FundReport_SubReport_1 29,'12-31-2016',57

CREATE PROC [dbo].[FundReport_SubReport_1_FundWise]
(@fundID      INT, 
 @date        DATETIME, 
 @portfolioID INT
)
AS
     DECLARE @companyName VARCHAR(1000);
     DECLARE @logo VARCHAR(1000);
     DECLARE @closingDate DATETIME;
     DECLARE @sector VARCHAR(1000);
     DECLARE @InvestedAmount_Equity DECIMAL(18, 6);
     DECLARE @InvestedAmount_All DECIMAL(18, 6);
     DECLARE @InvestedAmount_Debt DECIMAL(18, 6);
     DECLARE @InvestedAmount_Other DECIMAL(18, 6);
     DECLARE @detailProfile VARCHAR(1000);
     DECLARE @fundInvst TABLE
     (VehicleName VARCHAR(1000), 
      Amount      DECIMAL(18, 6)
     );
     INSERT INTO @fundInvst
            SELECT v.Name, 
            (
                SELECT SUM(sho.Amount)
                FROM tbl_PortfolioShareholdingOperations sho
                     JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = sho.SecurityID
                     JOIN tbl_portfoliosecuritytype pst ON pst.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
                WHERE sho.portfolioid = @portfolioID
                      AND ToTypeID = 3
                      AND toid = v.vehicleid
            )
            FROM tbl_vehicle v
                 JOIN tbl_portfoliovehicle pv ON v.vehicleid = pv.vehicleid
            WHERE pv.portfolioid = @portfolioID;
     SELECT *
     FROM @fundInvst
     UNION ALL
     SELECT 'Total fonds A Plus Finance', 
     (
         SELECT SUM(amount)
         FROM @fundInvst
     );
