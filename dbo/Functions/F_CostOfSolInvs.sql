
--  select * from dbo.F_CostOfSolInvs()     

CREATE FUNCTION [dbo].[F_CostOfSolInvs]
(
)
RETURNS @temptable TABLE
(CompanyID  INT, 
 SecurityID INT, 
 amount     DECIMAL(18, 4)
)
AS
     BEGIN
         DECLARE @tblResult TABLE
         (CompanyID   INT, 
          FundID      INT, 
          CompanyName VARCHAR(MAX), 
          SecurityID  INT, 
          amount      DECIMAL(18, 4)
         );
         DECLARE @tbl TABLE
         (id     INT, 
          fundid INT
         );
         INSERT INTO @tbl
                SELECT ROW_NUMBER() OVER(
                       ORDER BY vehicleID ASC), 
                       vehicleid
                FROM tbl_Vehicle;
         DECLARE @current INT;
         DECLARE @count INT;
         DECLARE @fundID INT;
         SET @current = 1;
         SET @count =
         (
             SELECT COUNT(1)
             FROM @tbl
         );
         WHILE(@current <= @count)
             BEGIN
                 SET @fundID =
                 (
                     SELECT fundid
                     FROM @tbl
                     WHERE id = @current
                 );
                 INSERT INTO @tblResult
                        SELECT cc.CompanyContactID, 
                               pv.VehicleID, 
                               cc.CompanyName, 
                               ps.PortfolioSecurityID, 
                               ISNULL(
                        (
                            SELECT SUM(amount)
                            FROM tbl_PortfolioShareholdingOperations spo
                            WHERE spo.ToTypeID = 3
                                  AND spo.ToID = @fundID
                                  AND spo.PortfolioID = p.portfolioid
                                  AND spo.SecurityID IN(ps.PortfolioSecurityID)
                        ), 0) * 1.0000 - CAST(ISNULL((CAST(
                        (
                        (
                            SELECT SUM(amount)
                            FROM tbl_PortfolioShareholdingOperations sho
                            WHERE sho.ToTypeID = 3
                                  AND sho.TOID = @fundID
                                  AND sho.PortfolioID = p.portfolioid
                                  AND sho.SecurityID IN(ps.PortfolioSecurityID)
                        )
                        ) AS DECIMAL(18, 2)) /
                        (
                        (
                            SELECT CASE
                                       WHEN SUM(Number) = 0
                                       THEN 1
                                       ELSE SUM(Number)
                                   END
                            FROM tbl_PortfolioShareholdingOperations sho
                            WHERE sho.TOTypeID = 3
                                  AND sho.TOID = @fundID
                                  AND sho.PortfolioID = p.portfolioid
                                  AND sho.SecurityID IN(ps.PortfolioSecurityID)
                        )
                        ) *
                        (
                            SELECT SUM(number)
                            FROM tbl_PortfolioShareholdingOperations sho
                            WHERE sho.FromTypeID = 3
                                  AND sho.FromID = @fundID
                                  AND sho.PortfolioID = p.portfolioid
                                  AND sho.SecurityID IN(ps.PortfolioSecurityID)
                        )), 0) AS DECIMAL(18, 6)) AS 'Amount invested'

             --ISNull((Select sum(amount) from tbl_PortfolioShareholdingOperations spo       
             --where spo.ToTypeID = 3 and spo.ToID = @fundID and spo.PortfolioID = p.portfolioid      
             --and spo.SecurityID in (ps.PortfolioSecurityID)),0) -       
             --ISNull((((Select SUM(amount) from tbl_PortfolioShareholdingOperations sho      
             -- where sho.ToTypeID = 3 and sho.TOID = @fundID and sho.PortfolioID = p.portfolioid      
             -- and sho.SecurityID in (ps.PortfolioSecurityID)      
             -- ))/      
             -- ISNull((Select case when SUM(Number) = 0 then 1 else SUM(Number) end from tbl_PortfolioShareholdingOperations sho      
             -- where sho.TOTypeID = 3 and sho.TOID = @fundID and sho.PortfolioID = p.portfolioid      
             -- and sho.SecurityID in (ps.PortfolioSecurityID)      
             -- ),0)*       
             -- ISNull((select sum(number) from tbl_PortfolioShareholdingOperations sho      
             -- where  sho.FromTypeID = 3 and sho.FromID = @fundID and sho.PortfolioID = p.portfolioid      
             -- and sho.SecurityID in (ps.PortfolioSecurityID)),0)),0) as 'Amount invested'      

                        FROM tbl_Portfolio p
                             INNER JOIN tbl_PortfolioVehicle pv ON p.portfolioid = pv.portfolioid
                             INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
                             JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = p.Portfolioid
                             JOIN tbl_Eligibility e ON e.objectmoduleid = p.Portfolioid
                                                       AND e.vehicleid = @fundID
                                                       AND e.moduleid = 7
                        WHERE pv.VehicleID = @fundID
                              AND pv.STATUS IN(1, 2, 3)      
                             --and cc.CompanyContactID = 2    
                             AND p.PortfolioID IN
                        (
                            SELECT *
                            FROM dbo.[F_CheckEligibility](@fundID)
                        )
                        ORDER BY cc.companyname ASC;
                 SET @current = @current + 1;
             END;
         INSERT INTO @temptable
                SELECT CompanyID, 
                       SecurityID, 
                       SUM(Amount) Amount
                FROM @tblResult
                GROUP BY CompanyID, 
                         SecurityID;
         RETURN;
     END;
