-- FundReport_SubReport_1 29,'12-31-2016',57

CREATE PROC [dbo].[FundReport_SubReport_1]
(@fundID      INT, 
 @date        DATETIME, 
 @portfolioID INT
)
AS
     DECLARE @companyName VARCHAR(1000);
     DECLARE @logo VARCHAR(1000);
     DECLARE @website VARCHAR(1000);
     DECLARE @HeadAddress VARCHAR(5000);
     DECLARE @Companyaddress VARCHAR(5000);
     DECLARE @businessDesc VARCHAR(MAX);
     DECLARE @businessUpdate VARCHAR(MAX);
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
     SELECT @companyName = CompanyName, 
            @logo = CompanyLogo, 
            @website = CompanyWebSite, 
            @HeadAddress =
     (
         SELECT OfficeAddress
         FROM tbl_CompanyOffice co
         WHERE co.CompanyContactID = cc.CompanyContactID
               AND co.IsMain = 1
     ), 
            @Companyaddress =
     (
         SELECT OfficeZip + ' ' + OfficeCity
         FROM tbl_CompanyOffice co
         WHERE co.CompanyContactID = cc.CompanyContactID
               AND co.IsMain = 1
     ), 
            @businessDesc = CompanyBusinessDesc, 
            @businessUpdate =
     (
         SELECT TOP 1 Comments
         FROM tbl_CompanyBusinessUpdates cu
         WHERE cu.CompanyID = cc.companycontactid
               AND cu.date <= @date
         ORDER BY cu.Date DESC
     ), 
            @sector = ba.BusinessAreaTitle
     FROM tbl_portfolio p
          JOIN tbl_companycontact cc ON cc.companycontactid = p.TargetPortfolioID
          JOIN tbl_BusinessArea ba ON ba.BusinessAreaID = cc.CompanyBusinessAreaID
     WHERE p.portfolioid = @portfolioID;
     SET @closingDate =
     (
         SELECT TOP 1 pso.Date
         FROM tbl_PortfolioShareholdingOperations pso
         WHERE pso.ToID = @fundID
               AND pso.PortfolioID = @portfolioID
               AND pso.ToTypeID = 3
         ORDER BY Date
     );
     SET @InvestedAmount_All =
     (
         SELECT SUM(sho.Amount)
         FROM tbl_PortfolioShareholdingOperations sho
              JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = sho.SecurityID
              JOIN tbl_portfoliosecuritytype pst ON pst.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
         WHERE sho.portfolioid = @portfolioID
               AND ToTypeID = 3
               AND toid = @fundID
     );
     SET @InvestedAmount_Equity =
     (
         SELECT SUM(sho.Amount)
         FROM tbl_PortfolioShareholdingOperations sho
              JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = sho.SecurityID
              JOIN tbl_portfoliosecuritytype pst ON pst.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
         WHERE sho.portfolioid = @portfolioID
               AND pst.SecurityGroupID = 1 -- Equity

               AND ToTypeID = 3
               AND toid = @fundID
     );
     SET @InvestedAmount_Debt =
     (
         SELECT SUM(sho.Amount)
         FROM tbl_PortfolioShareholdingOperations sho
              JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = sho.SecurityID
              JOIN tbl_portfoliosecuritytype pst ON pst.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
         WHERE sho.portfolioid = @portfolioID
               AND pst.SecurityGroupID = 2 -- Debt

               AND ToTypeID = 3
               AND toid = @fundID
     );
     SET @InvestedAmount_Other =
     (
         SELECT SUM(sho.Amount)
         FROM tbl_PortfolioShareholdingOperations sho
              JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = sho.SecurityID
              JOIN tbl_portfoliosecuritytype pst ON pst.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
         WHERE sho.portfolioid = @portfolioID
               AND pst.SecurityGroupID = 3 -- Other

               AND ToTypeID = 3
               AND toid = @fundID
     );
     SET @detailProfile =
     (
         SELECT InvestmentRiskAssessment
         FROM tbl_PortfolioOptional
         WHERE portfolioid = @portfolioID
     );
     SELECT @companyName CompanyName, 
            'http://gvepeps.officectbr.ch/LBOPicturelib/' + @logo Logo, 
            @sector Sector, 
            @closingDate ClosingDate, 
            @InvestedAmount_Equity InvestedAmount_Equity, 
            @InvestedAmount_All InvestedAmount_All, 
            @InvestedAmount_Debt InvestedAmount_Debt, 
            @InvestedAmount_Other InvestedAmount_Other, 
            @detailProfile DetailProfile, 
            @website Website, 
            @Headaddress HeadAddress, 
            @Companyaddress CompanyAddress, 
            @businessDesc BusinessDesc, 
            @businessUpdate BusinessUpdate;

/*****Portfolio Grid*********/

