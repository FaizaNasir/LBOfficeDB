
-- proc_PortfolioPartiallyRealized 30                           

CREATE PROC [dbo].[proc_PortfolioPartiallyRealized](@fundiD INT)
AS
    BEGIN
        DECLARE @tblResult TABLE
        (CompanyID INT, 
         amount    DECIMAL(18, 4)
        );
        DECLARE @tblFinalResult TABLE
        (CompanyID INT, 
         amount    DECIMAL(18, 4)
        );
        INSERT INTO @tblResult
               SELECT DISTINCT 
                      cc.CompanyContactID, 
                      ISNULL(
               (
                   SELECT SUM(amount)
                   FROM tbl_PortfolioShareholdingOperations spo
                   WHERE spo.ToTypeID = 3
                         AND spo.ToID = @fundID
                         AND spo.PortfolioID = p.portfolioid
                         AND spo.SecurityID IN(ps.PortfolioSecurityID)
               ), 0) - ISNULL((
               (
               (
                   SELECT SUM(amount)
                   FROM tbl_PortfolioShareholdingOperations sho
                   WHERE sho.ToTypeID = 3
                         AND sho.TOID = @fundID
                         AND sho.PortfolioID = p.portfolioid
                         AND sho.SecurityID IN(ps.PortfolioSecurityID)
               )
               ) /
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
                   AND Date < DATEADD(year, -2, GETDATE())
               )), 0) AS 'Amountinvested'
               FROM tbl_Portfolio p
                    INNER JOIN tbl_PortfolioVehicle pv ON p.portfolioid = pv.portfolioid
                    INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
                    LEFT OUTER JOIN tbl_CompanyBusinessUpdates cb ON cb.CompanyID = p.TargetPortfolioID
                                                                     AND cb.Date <= GETDATE()
                    LEFT OUTER JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = p.Portfolioid
                    LEFT OUTER JOIN tbl_Eligibility e ON e.objectmoduleid = p.Portfolioid
                                                         AND e.vehicleid = @fundID
                                                         AND e.moduleid = 7
               WHERE pv.VehicleID = @fundID
                     AND pv.STATUS IN(1, 2, 3);

        --and p.PortfolioID in            
        --(select * from dbo.[F_CheckEligibility](@fundID)            
        --)            

        INSERT INTO @tblFinalResult
               SELECT CompanyID, 
                      SUM(amount)
               FROM @tblResult
               GROUP BY CompanyID;
        SELECT c.CompanyContactID, 
               p.PortfolioID, 
               c.CompanyName 'ComapanyName', 
               b.BusinessAreaTitle 'Sector', 
        (
            SELECT TOP 1 pso.Date
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.ToID = @fundiD
                  AND pso.PortfolioID = p.PortfolioID
                  AND pso.ToTypeID = 3
            ORDER BY Date
        ) 'InvestmentDate', 
        (
        (
            SELECT TOP 1 InvestmentValue
            FROM tbl_PortfolioValuation pso
            WHERE pso.PortfolioID = p.PortfolioID
                  AND pso.VehicleID = pv.VehicleID
            ORDER BY Date DESC
        )

               --    +                            
               -- ISNULL((select Sum(pso.amount) from tbl_PortfolioShareholdingOperations pso                              
               --where pso.fromid = @fundiD and pso.FromTypeID = 3                         
               --and pso.portfolioid = p.PortfolioID ),0)                      
               --+                      
               --ISNULL((                      
               --select ISNULL(SUM(Amount),0) from tbl_PortfolioGeneralOperation g         
               --where g.PortfolioID = p.PortfolioID                      
               --and TypeID in (1,2,3)                      
               --),0)  

        ) 'PotentialProceeds', 
               dbo.[F_NonDiluted](c.CompanyContactID, 5, GETDATE(), p.PortfolioID) 'Owned', 
               d.amount AS 'AmountInvested',

        --,pv.Amount                              
               CAST(pv.Amount * 100.0 /
        (
            SELECT SUM(cc.Amount)
            FROM tbl_PortfolioVehicle cc
            WHERE cc.VehicleID = @fundiD
                  AND STATUS = 2
        ) AS DECIMAL(18, 2)) 'PortfolioWeight', 
               c.CompanyBusinessDesc 'CompanyComments', 
               dbo.[F_Sold](@fundiD, 3, p.PortfolioID) 'Sold', 
               CAST(((
        (
            SELECT TOP 1 InvestmentValue
            FROM tbl_PortfolioValuation pso
            WHERE pso.PortfolioID = p.PortfolioID
                  AND pso.VehicleID = pv.VehicleID
            ORDER BY Date DESC
        ) / ISNULL(
        (
            SELECT CASE
                       WHEN SUM(pso.amount) = 0
                       THEN 1
                       ELSE SUM(pso.amount)
                   END
            FROM tbl_PortfolioShareholdingOperations pso
            WHERE pso.fromid = @fundiD
                  AND pso.FromTypeID = 3
                  AND pso.portfolioid = p.PortfolioID
        ), 1)) / CASE
                     WHEN(ISNULL(pv.Amount, 1)) = 0
                     THEN 1
                     ELSE(ISNULL(pv.Amount, 1))
                 END

        --(ISNULL(pv.Amount,1))          

        ) AS DECIMAL(18, 2)) 'Multiple', 
        (
            SELECT TOP 1 pval.ValuationID
            FROM tbl_PortfolioValuation pval
            WHERE pval.PortfolioID = pv.PortfolioID
                  AND pval.VehicleID = pv.VehicleID
            ORDER BY pval.Date DESC
        ) ValuationID
        FROM tbl_PortfolioVehicle pv
             JOIN tbl_Portfolio p ON pv.PortfolioID = p.PortfolioID
             JOIN tbl_companycontact c ON c.CompanyContactID = p.TargetPortfolioID
             LEFT OUTER JOIN tbl_businessarea b ON c.CompanyBusinessAreaID = b.BusinessAreaID
             JOIN @tblFinalResult d ON d.CompanyID = p.TargetPortfolioID
        WHERE VehicleID = @fundiD
              AND STATUS IN(1, 2)
        ORDER BY companyname;
    END;
