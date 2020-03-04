-- FundReport_SubReport_2 29,'12-31-2016',57

CREATE PROC [dbo].[FundReport_SubReport_2]
(@fundID      INT, 
 @date        DATETIME, 
 @portfolioID INT
)
AS
     DECLARE @companyName VARCHAR(1000);
     DECLARE @logo VARCHAR(1000);
     DECLARE @closingDate DATETIME;
     DECLARE @sector VARCHAR(1000);
     DECLARE @detailProfile VARCHAR(1000);
     DECLARE @fundInvst TABLE
     (VehicleName VARCHAR(1000), 
      Amount      DECIMAL(18, 6)
     );
     SELECT @companyName = CompanyName, 
            @logo = CompanyLogo, 
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
            @detailProfile DetailProfile;

/*****Portfolio Grid*********/

