CREATE PROC [dbo].[FundReport_DealTeam](@fundID INT)
AS
     DECLARE @tblPortfolio TABLE(ID INT);
     INSERT INTO @tblPortfolio
            SELECT portfolioid
            FROM tbl_portfoliovehicle pv
            WHERE pv.vehicleID = @fundID;
     SELECT t.*, 
            CompanyName
     FROM
     (
         SELECT PortfolioID, 
                'Membre du Conseil d’administration' LEAD
         FROM tbl_PortfolioDealTeam
         WHERE roleid = 'Membre du Conseil d’administration'
               AND portfolioid IN
         (
             SELECT *
             FROM @tblPortfolio
         )
         UNION ALL
         SELECT PortfolioID, 
                'Membre du Conseil d’administration'
         FROM tbl_PortfolioDealTeam
         WHERE roleid = 'Membre du Conseil de Surveillance'
               AND portfolioid IN
         (
             SELECT *
             FROM @tblPortfolio
         )
         UNION ALL
         SELECT PortfolioID, 
                'Membre du Conseil d’administration'
         FROM tbl_PortfolioDealTeam
         WHERE roleid = 'Censeur au Conseil de Surveillance'
               AND portfolioid IN
         (
             SELECT *
             FROM @tblPortfolio
         )
     ) t
     JOIN tbl_portfolio p ON p.portfolioid = t.portfolioid
     JOIN tbl_companycontact cc ON cc.companycontactid = p.targetportfolioid
     ORDER BY LEAD, 
              companyname;
