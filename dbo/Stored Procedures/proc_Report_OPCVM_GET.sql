
-- [proc_Report_OPCVM_GET] 12            

CREATE PROCEDURE [dbo].[proc_Report_OPCVM_GET](@fundID INT)
AS
    BEGIN
        DECLARE @sho AS SHOTYPE;

        --select * from dbo.[F_CheckEligibility](@vehicleID)            

        INSERT INTO @sho
               SELECT ShareholdingOperationID, 
                      PortfolioID, 
                      Date, 
                      Amount, 
                      SecurityID, 
                      Number, 
                      FromID, 
                      ToID, 
                      FromTypeID, 
                      ToTypeID, 
                      NatureID
               FROM tbl_portfolioShareHoldingOperations
               WHERE 1 = (CASE
                              WHEN FromTypeID = 3
                                   AND FromID = @fundID
                              THEN 1
                              WHEN ToTypeID = 3
                                   AND ToID = @fundID
                              THEN 1
                          END);
        SELECT DISTINCT 
               psc.ClassName, 
               ps.Name, 
               ps.ISIN, 
               pv.VehicleID, 
               ISNULL(
        (
            SELECT TOP 1 vs.NetAssets
            FROM tbl_VehicleShare vs
            WHERE vs.VehicleID = @fundID
        ), 1) AS 'Net Asset Value', 
               ISNULL(
        (
            SELECT SUM(Number)
            FROM tbl_PortfolioShareholdingOperations
            WHERE FromTypeID = 3
                  AND FromID = @fundID
                  AND PortfolioID = p.portfolioid
                  AND securityid IN(ps.PortfolioSecurityID)
        ), 0) AS 'Saleing', 
               ISNULL(
        (
            SELECT SUM(Number)
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @fundID
                  AND PortfolioID = p.portfolioid
                  AND securityid IN(ps.PortfolioSecurityID)
        ), 0) AS 'Buying', 
               ISNULL(
        (
            SELECT TOP 1 pvd.value
            FROM tbl_PortfolioValuation pv
                 INNER JOIN tbl_PortfolioValuationDetails pvd ON pv.ValuationID = pvd.ValuationID
            WHERE pv.vehicleid = @fundID
                  AND pv.portfolioid = p.portfolioid
                  AND pvd.securityid IN(ps.PortfolioSecurityID)
            ORDER BY date DESC
        ), 0) AS 'Last value of security',

        -- ,ISNULL((select SUM(Amount) from tbl_PortfolioShareholdingOperations sho      
        -- --inner join  tbl_PortfolioSecurity s ON      
        -- --sho.SecurityID = s.PortfolioSecurityID      
        --where sho.FromTypeID = 3 and sho.FromID = @fundID      
        --and sho.SecurityID in (ps.PortfolioSecurityID) ),0)as 'Amount invested'       
               ISNULL(
        (
            SELECT SUM(Amount)
            FROM tbl_PortfolioShareholdingOperations sho

            --inner join  tbl_PortfolioSecurity s ON      
            --sho.SecurityID = s.PortfolioSecurityID   
            --and s.PortfolioSecurityTypeID = 11        

            WHERE sho.ToTypeID = 3
                  AND sho.ToID = @fundID
                  AND sho.SecurityID IN(ps.PortfolioSecurityID)
        ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_WithOutEligibility](@sho, NULL, ps.PortfolioSecurityID, @fundID), 0) AS 'Amount invested'
        FROM tbl_Portfolio p
             INNER JOIN tbl_PortfolioVehicle pv ON p.PortfolioID = pv.PortfolioID
             INNER JOIN tbl_PortfolioSecurity ps ON p.PortfolioID = ps.PortfolioID
             INNER JOIN tbl_PortfolioShareholdingOperations pso ON pso.PortfolioID = p.PortfolioID
                                                                   AND pso.SecurityID = ps.PortfolioSecurityID
             INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
             LEFT OUTER JOIN tbl_PortfolioSecurityClass psc ON ps.ClassID = psc.ClassID
        WHERE pv.STATUS = 4
              AND VehicleID = @fundID
              AND ps.PortfolioSecurityTypeID = 11
              AND ((FromTypeID = 3
                    AND FromID = VehicleID)
                   OR (ToTypeID = 3
                       AND ToID = VehicleID))
        ORDER BY ps.Name;
    END;
