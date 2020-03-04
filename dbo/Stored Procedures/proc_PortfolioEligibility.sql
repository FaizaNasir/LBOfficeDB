
-- [proc_PortfolioEligibility] 15,89          

CREATE PROC [dbo].[proc_PortfolioEligibility]
(@vehicleID   INT, 
 @portfolioID INT
)
AS
     DECLARE @isEligibile BIT;
     DECLARE @CostOfSold DECIMAL(18, 6);
     DECLARE @originVal DECIMAL(18, 6);
     DECLARE @RatioPrinciple DECIMAL(18, 4);
     DECLARE @RatioCapital DECIMAL(18, 4);
     DECLARE @Ratio5Year DECIMAL(18, 4);
     DECLARE @Ratio8Year DECIMAL(18, 4);
     DECLARE @RatioReglemente DECIMAL(18, 4);
     DECLARE @RatioNonRelemente DECIMAL(18, 4);
     DECLARE @RatioCapitalIncrease DECIMAL(18, 4);
     DECLARE @RatioConvertibaleBonds DECIMAL(18, 4);
     DECLARE @RatioTransferSecurity DECIMAL(18, 4);
     DECLARE @RatioCurrentAccount DECIMAL(18, 4);
     DECLARE @RatioRegion DECIMAL(18, 4);
     DECLARE @totalamountofordinarybond DECIMAL(18, 4);
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
                                AND FromID = @vehicleID
                           THEN 1
                           WHEN ToTypeID = 3
                                AND ToID = @vehicleID
                           THEN 1
                       END)
                  AND PortfolioID IN
            (
                SELECT *
                FROM dbo.[F_CheckEligibility](@vehicleID)
            );
     SET @originVal =
     (
         SELECT AssetsofOrigin
         FROM tbl_VehicleShare
         WHERE vehicleID = @vehicleID
     );
     IF @originVal = 0
         BEGIN
             SELECT 'Success' AS Result, 
                    0 AS 'VehicleRatioID';
             RETURN;
     END;
     SET @totalamountofordinarybond = ISNULL(
     (
         SELECT SUM(Amount)
         FROM @sho sho
              INNER JOIN tbl_PortfolioSecurity ps ON sho.SecurityID = ps.PortfolioSecurityID
              INNER JOIN tbl_PortfolioSecurityType pst ON ps.PortfolioSecurityTypeID = pst.PortfolioSecurityTypeID
         WHERE sho.ToTypeID = 3
               AND sho.ToID = @vehicleID
               AND pst.PortfolioSecurityTypeID = 5
     ), 0);

     -------------------------------------------------------------------------         
     --(select * from @sho a          
     -- inner join tbl_portfolioShareHoldingOperations sh          
     -- on a.ShareholdingOperationID = sh.ShareholdingOperationID          
     -- join tbl_eligibility b on a.portfolioID = b.objectModuleID          
     -- and b.VehicleID = @VehicleID and b.moduleid = 7           
     -- where a.FromTypeID <> 3 and QuotationID = 2)          
     --(select SUM(Amount) from @sho          
     --where FromID <> -1 and natureID = 1)          
     --(select cc.CompanyName,s.* from @sho s          
     --inner join tbl_Portfolio p on s.PortfolioID = p.PortfolioID          
     --inner join tbl_CompanyContact cc on cc.CompanyContactID = p.TargetPortfolioID          
     --where FromTypeID <> 3          
     --)          
     -- Select @originVal          
     --select SUM(Amount) from @sho          
     -- where FromTypeID <> 3 and natureID = 3          
     --select dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho,null,null,9,@vehicleID)          
     --return          
     ---------------------------------------------------------------------           

     SET @RatioPrinciple = (ISNULL(
     (
         SELECT SUM(Amount)
         FROM @sho
         WHERE FromTypeID <> 3
     ), 0) - @totalamountofordinarybond - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 1, NULL), 0)) / @originVal;

     --select @RatioPrinciple        
     --return;        
     --if exists (select top 1 1 from tbl_eligibility where moduleid = 7           
     --     and objectModuleID = @portfolioID           
     --     )          

     SET @RatioCapital = (
     (
         SELECT SUM(Amount)
         FROM @sho a
              JOIN tbl_eligibility b ON a.portfolioID = b.objectModuleID
                                        AND b.VehicleID = @VehicleID
                                        AND b.moduleid = 7
         WHERE a.FromTypeID <> 3
               AND IsCapital = 1
     ) - ISNULL(
     (
         SELECT SUM(Amount)
         FROM tbl_portfolioShareHoldingOperations sho
              INNER JOIN tbl_PortfolioSecurity ps ON sho.SecurityID = ps.PortfolioSecurityID
              INNER JOIN tbl_PortfolioSecurityType pst ON ps.PortfolioSecurityTypeID = pst.PortfolioSecurityTypeID
              JOIN tbl_eligibility b ON sho.portfolioID = b.objectModuleID
                                        AND b.VehicleID = @vehicleID
                                        AND b.moduleid = 7
         WHERE sho.ToTypeID = 3
               AND sho.ToID = @vehicleID
               AND pst.PortfolioSecurityTypeID = 5
               AND IsCapital = 1
     ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 2, @vehicleID), 0)) / @originVal;
     SET @Ratio5Year = (
     (
         SELECT SUM(Amount)
         FROM @sho a
              JOIN tbl_eligibility b ON a.portfolioID = b.objectModuleID
                                        AND b.VehicleID = @VehicleID
                                        AND b.moduleid = 7
         WHERE a.FromTypeID <> 3
               AND IsCompanylessthan5Years = 1
     ) - ISNULL(
     (
         SELECT SUM(Amount)
         FROM tbl_portfolioShareHoldingOperations sho
              INNER JOIN tbl_PortfolioSecurity ps ON sho.SecurityID = ps.PortfolioSecurityID
              INNER JOIN tbl_PortfolioSecurityType pst ON ps.PortfolioSecurityTypeID = pst.PortfolioSecurityTypeID
              JOIN tbl_eligibility b ON sho.portfolioID = b.objectModuleID
                                        AND b.VehicleID = @vehicleID
                                        AND b.moduleid = 7
         WHERE sho.ToTypeID = 3
               AND sho.ToID = @vehicleID
               AND pst.PortfolioSecurityTypeID = 5
               AND IsCompanylessthan5Years = 1
     ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 3, @vehicleID), 0)) / @originVal;
     SET @Ratio8Year = (
     (
         SELECT SUM(Amount)
         FROM @sho a
              JOIN tbl_eligibility b ON a.portfolioID = b.objectModuleID
                                        AND b.VehicleID = @VehicleID
                                        AND b.moduleid = 7
         WHERE a.FromTypeID <> 3
               AND IsCompanylessthan8Years = 1
     ) - ISNULL(
     (
         SELECT SUM(Amount)
         FROM tbl_portfolioShareHoldingOperations sho
              INNER JOIN tbl_PortfolioSecurity ps ON sho.SecurityID = ps.PortfolioSecurityID
              INNER JOIN tbl_PortfolioSecurityType pst ON ps.PortfolioSecurityTypeID = pst.PortfolioSecurityTypeID
              JOIN tbl_eligibility b ON sho.portfolioID = b.objectModuleID
                                        AND b.VehicleID = @vehicleID
                                        AND b.moduleid = 7
         WHERE sho.ToTypeID = 3
               AND sho.ToID = @vehicleID
               AND pst.PortfolioSecurityTypeID = 5
               AND IsCompanylessthan8Years = 1
     ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 4, @vehicleID), 0)) / @originVal;
     SET @RatioReglemente = (
     (
         SELECT SUM(Amount)
         FROM @sho a
              JOIN tbl_eligibility b ON a.portfolioID = b.objectModuleID
                                        AND b.VehicleID = @VehicleID
                                        AND b.moduleid = 7
         WHERE a.FromTypeID <> 3
               AND QuotationID = 2
     ) - ISNULL(
     (
         SELECT SUM(Amount)
         FROM tbl_portfolioShareHoldingOperations sho
              INNER JOIN tbl_PortfolioSecurity ps ON sho.SecurityID = ps.PortfolioSecurityID
              INNER JOIN tbl_PortfolioSecurityType pst ON ps.PortfolioSecurityTypeID = pst.PortfolioSecurityTypeID
              JOIN tbl_eligibility b ON sho.portfolioID = b.objectModuleID
                                        AND b.VehicleID = @vehicleID
                                        AND b.moduleid = 7
         WHERE sho.ToTypeID = 3
               AND sho.ToID = @vehicleID
               AND pst.PortfolioSecurityTypeID = 5
               AND QuotationID = 2
     ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 5, @vehicleID), 0)) / @originVal;
     SET @RatioNonRelemente = (
     (
         SELECT SUM(Amount)
         FROM @sho a
              JOIN tbl_eligibility b ON a.portfolioID = b.objectModuleID
                                        AND b.VehicleID = @VehicleID
                                        AND b.moduleid = 7
         WHERE a.FromTypeID <> 3
               AND QuotationID = 3
     ) - ISNULL(
     (
         SELECT SUM(Amount)
         FROM tbl_portfolioShareHoldingOperations sho
              INNER JOIN tbl_PortfolioSecurity ps ON sho.SecurityID = ps.PortfolioSecurityID
              INNER JOIN tbl_PortfolioSecurityType pst ON ps.PortfolioSecurityTypeID = pst.PortfolioSecurityTypeID
              JOIN tbl_eligibility b ON sho.portfolioID = b.objectModuleID
                                        AND b.VehicleID = @vehicleID
                                        AND b.moduleid = 7
         WHERE sho.ToTypeID = 3
               AND sho.ToID = @vehicleID
               AND pst.PortfolioSecurityTypeID = 5
               AND QuotationID = 3
     ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 6, @vehicleID), 0)) / @originVal;
     SET @RatioCapitalIncrease = (
     (
         SELECT SUM(Amount)
         FROM @sho
         WHERE FromID = -1
               AND natureID = 1
     ) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 7, @vehicleID), 0)) / @originVal;
     SET @RatioConvertibaleBonds = (
     (
         SELECT SUM(Amount)
         FROM @sho
         WHERE FromTypeID <> 3
               AND natureID = 2
     ) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 8, @vehicleID), 0)) / @originVal;
     SET @RatioTransferSecurity = (
     (
         SELECT SUM(Amount)
         FROM @sho
         WHERE FromTypeID <> 3
               AND natureID = 3
     ) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 9, @vehicleID), 0)) / @originVal;
     SET @RatioCurrentAccount = (
     (
         SELECT SUM(Amount)
         FROM @sho
         WHERE FromTypeID <> 3
               AND natureID = 4
     ) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 10, @vehicleID), 0)) / @originVal;
     SET @RatioRegion = (
     (
         SELECT SUM(Amount)
         FROM @sho a
              JOIN tbl_VehicleEligibility b ON a.ToId = b.vehicleid
                                               AND a.totypeid = 3
              JOIN tbl_VehicleEligibilityRegion c ON c.VehicleEligibilityID = b.VehicleEligibilityID
         WHERE FromTypeID <> 3
               AND c.RegionID IN
         (
             SELECT RegionID
             FROM tbl_eligibilityRegion x
                  JOIN tbl_eligibility y ON x.EligibilityID = y.EligibilityID
                                            AND y.VehicleID = @VehicleID
                                            AND moduleID = 7
                                            AND PortfolioID IN
             (
                 SELECT *
                 FROM dbo.[F_CheckEligibility](@vehicleID)
             )
         )
     ) - dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 11, @vehicleID)) / @originVal;

     --select ISNULL((select SUM(Amount) from @sho          
     --where FromTypeID <> 3 ),0) , @totalamountofordinarybond ,  
     -- ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho,null,null,1,null),0)    
     -- ,@originVal          
     --select (ISNULL((select SUM(Amount) from @sho          
     --where FromTypeID <> 3 ),0) - @totalamountofordinarybond - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho,null,null,1,null),0)  )/@originVal          

     DELETE FROM tbl_vehicleRatio
     WHERE vehicleID = @vehicleID;
     INSERT INTO tbl_vehicleRatio
     (VehicleID, 
      RatioPrinciple, 
      RatioCapital, 
      Ratio5Year, 
      Ratio8Year, 
      RatioReglemente, 
      RatioNonRelemente, 
      RatioCapitalIncrease, 
      RatioConvertibaleBonds, 
      RatioTransferSecurity, 
      RatioCurrentAccount, 
      RatioRegion
     )
            SELECT @VehicleID, 
                   @RatioPrinciple * 100, 
                   @RatioCapital * 100, 
                   @Ratio5Year * 100, 
                   @Ratio8Year * 100, 
                   @RatioReglemente * 100, 
                   @RatioNonRelemente * 100, 
                   @RatioCapitalIncrease * 100, 
                   @RatioConvertibaleBonds * 100, 
                   @RatioTransferSecurity * 100, 
                   @RatioCurrentAccount * 100, 
                   @RatioRegion * 100;
     DECLARE @VehicleRatioID INT;
     SET @VehicleRatioID =
     (
         SELECT TOP 1 VehicleRatioID
         FROM tbl_vehicleRatio
         WHERE VehicleID = @VehicleID
     );
     SELECT 'Success' AS Result, 
            @VehicleRatioID AS 'VehicleRatioID';
