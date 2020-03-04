
--  select * from dbo.[F_PortfolioCal](66)              

CREATE FUNCTION [dbo].[F_PortfolioCal_bk]
(@vehicleID INT
)
RETURNS @result TABLE
(STATUS           INT, 
 vehicleid        INT, 
 Fundname         VARCHAR(100), 
 CompanyContactid INT, 
 Comapnyname      VARCHAR(MAX), 
 Industry         VARCHAR(MAX), 
 Sector           VARCHAR(MAX), 
 ClosingDate      DATETIME, 
 Investment       DECIMAL(18, 2), 
 Divestment       DECIMAL(18, 2), 
 LastValuation    DECIMAL(18, 2), 
 Dividends        DECIMAL(18, 2), 
 AcquisitionFees  DECIMAL(18, 2), 
 Portfolioid      INT
)
AS
     BEGIN
         INSERT INTO @result
                SELECT pv.STATUS, 
                       pv.VehicleID, 
                       v.Name, 
                       cc.CompanyContactID, 
                       cc.CompanyName AS 'Company name',            
                       --cc.CompanyAddress as 'Address',            
                       --cc.CompanyPOBox as 'Zip code',          
                       --c.CityName as 'City',            
                       --cn.CountryName as 'Country',            
                       --cc.CompanyPhone as 'Phone',            
                       --cc.CompanyFax as 'Fax',            
                       --cc.CompanyWebSite as 'Website',            
                       --cc.CompanyComments as 'Notes',           
                       ci.CompanyIndustryTitle, 
                       ba.BusinessAreaTitle, 
                       [dbo].[F_ClosingDate](pv.VehicleID, p.PortfolioID), 
                       CAST(
                (
                    SELECT ISNULL(SUM(Amount), 0)
                    FROM tbl_PortfolioShareholdingOperations
                    WHERE ToTypeID = 3
                          AND ToID = @vehicleID
                          AND PortfolioID = p.PortfolioID
                          AND isConditional = 0
                ) AS DECIMAL(18, 2)) + CAST(ISNULL(
                (
                    SELECT TOP 1 CASE
                                     WHEN
                    (
                        SELECT FromTypeID
                        FROM tbl_PortfolioShareholdingOperations s
                        WHERE ShareholdingOperationID = pfp.ShareholdingOperationID
                    ) = 3
                                     THEN ISNULL(SUM(pfp.AmountDue * -1), 0)
                                     ELSE ISNULL(SUM(pfp.AmountDue), 0)
                                 END
                    FROM tbl_PortfolioFollowOnPayment pfp
                         INNER JOIN tbl_PortfolioShareholdingOperations pso ON pso.ShareholdingOperationID = pfp.ShareholdingOperationID
                    WHERE pso.PortfolioID = p.portfolioid
                          AND isConditional = 0
                    GROUP BY pfp.ShareholdingOperationID
                ), 0) AS DECIMAL(18, 2)) + CAST(
                (
                    SELECT ISNULL(SUM(Amount), 0)
                    FROM tbl_PortfolioGeneralOperation g
                    WHERE g.PortfolioID = p.PortfolioID
                          AND g.IsConditional = 0
                          AND g.toID = p.TargetPortfolioID
                          AND g.toModuleID = 5
                          AND g.FromModuleID = 3
                          AND g.fromID = @vehicleID
                          AND TypeID = 9
                ) AS DECIMAL(18, 2)), 
                       ISNULL(
                (
                    SELECT SUM(Amount)
                    FROM tbl_PortfolioShareholdingOperations
                    WHERE FromTypeID = 3
                          AND FromID = @vehicleID
                          AND PortfolioID = p.PortfolioID
                ), 0) +
                (
                    SELECT ISNULL(SUM(Amount), 0)
                    FROM tbl_PortfolioGeneralOperation g
                    WHERE g.PortfolioID = p.PortfolioID
                          AND g.IsConditional = 0
                          AND g.FromID = p.TargetPortfolioID
                          AND g.FromModuleID = 5
                          AND g.ToModuleID = 3
                          AND g.toID = @vehicleID
                          AND TypeID = 9
                ),

                       --,(Select top 1   sum(pv.investmentvalue)             
                       --from  tbl_PortfolioValuation pv            
                       --where pv.vehicleid @vehicleID          
                       --and portfolioid = p.portfolioid             
                       --and      DATE <= GETDATE() ) as 'Last valuation'           
                       SUM([dbo].[F_Last_Valuation](pv.VehicleID, p.PortfolioID, GETDATE())), 
                (
                    SELECT SUM(amount)
                    FROM tbl_PortfolioGeneralOperation s
                    WHERE toModuleID = 3
                          AND toid = @vehicleID
                          AND portfolioid = p.portfolioid
                          AND typeid = 1
                          AND DATE <= GETDATE()
                ), 
                (
                    SELECT SUM(amount)
                    FROM tbl_PortfolioGeneralOperation s
                    WHERE fromModuleID = 3
                          AND FromID = @vehicleID
                          AND portfolioid = p.portfolioid
                          AND typeid = 5
                          AND DATE <= GETDATE()
                ), 
                       p.PortfolioID
                FROM tbl_Portfolio p
                     INNER JOIN tbl_PortfolioVehicle pv ON p.PortfolioID = pv.PortfolioID
                     INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
                     LEFT OUTER JOIN tbl_City c ON cc.CompanyCityID = c.CityID
                     LEFT OUTER JOIN tbl_Country cn ON cc.CompanyCountryID = cn.CountryID
                     LEFT OUTER JOIN tbl_CompanyIndustries ci ON cc.CompanyIndustryID = ci.CompanyIndustryID
                     LEFT OUTER JOIN tbl_BusinessArea ba ON ba.BusinessAreaID = cc.CompanyBusinessAreaID
                     LEFT OUTER JOIN tbl_Vehicle v ON v.VehicleID = pv.VehicleID
                WHERE pv.VehicleID = @vehicleID
                GROUP BY pv.STATUS, 
                         pv.VehicleID, 
                         v.Name, 
                         cc.CompanyContactID, 
                         cc.CompanyName, 
                         ci.CompanyIndustryTitle, 
                         ba.BusinessAreaTitle, 
                         p.PortfolioID, 
                         p.TargetPortfolioID;
         RETURN;
     END; 
