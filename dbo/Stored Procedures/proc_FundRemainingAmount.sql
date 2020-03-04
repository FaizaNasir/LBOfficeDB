CREATE PROC [dbo].[proc_FundRemainingAmount](@vehicleID INT)
AS
     DECLARE @CostOfSold DECIMAL(18, 6);
     DECLARE @originVal DECIMAL(18, 6);
     DECLARE @PercentageEligibile DECIMAL(18, 4);
     DECLARE @Remainingamounttoinvest DECIMAL(18, 4);
     DECLARE @RemainingamounttoinvestinAK DECIMAL(18, 4);
     DECLARE @RatiominimuminAK DECIMAL(18, 4);
     DECLARE @totalamountofordinarybond DECIMAL(18, 4);
     DECLARE @sho AS SHOTYPE;
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
     SET @originVal = ISNULL(
     (
         SELECT AssetsofOrigin
         FROM tbl_VehicleShare
         WHERE vehicleID = @vehicleID
     ), 0);
     SET @PercentageEligibile = ISNULL(
     (
         SELECT PercentageEligibile
         FROM tbl_VehicleEligibility
         WHERE VehicleID = @vehicleID
     ), 0) / 100;
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
     SET @Remainingamounttoinvest = ((@PercentageEligibile * @originVal) - (ISNULL(
     (
         SELECT SUM(Amount)
         FROM @sho
         WHERE FromTypeID <> 3
     ), 0) - @totalamountofordinarybond

                                                                            -- - ISNULL((Select SUM(Amount) from @sho sho      
                                                                            --inner join tbl_PortfolioSecurity ps      
                                                                            --on sho.SecurityID = ps.PortfolioSecurityID      
                                                                            --inner join tbl_PortfolioSecurityType pst      
                                                                            --on ps.PortfolioSecurityTypeID = pst.PortfolioSecurityTypeID      
                                                                            --where sho.ToTypeID = 3 and sho.ToID = @vehicleID      
                                                                            --and pst.PortfolioSecurityTypeID = 5),0)     

                                                                            - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 1, NULL), 0)));
     SET @RatiominimuminAK = ISNULL(
     (
         SELECT MinRatioCapitalIncrease
         FROM tbl_VehicleEligibility
         WHERE VehicleID = @vehicleID
     ), 0) / 100;

     --  select @RatiominimuminAK,@originVal,      
     --  ISNULL((select SUM(Amount) from @sho          
     --where FromID = -1 and natureID = 1),0),      
     --ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho,null,null,7,@vehicleID),0)      

     SET @RemainingamounttoinvestinAK = ((@RatiominimuminAK * @originVal) - (ISNULL(
     (
         SELECT SUM(Amount)
         FROM @sho
         WHERE FromID = -1
               AND natureID = 1
     ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 7, @vehicleID), 0)));
     SELECT @Remainingamounttoinvest AS 'Remainingamounttoinvest', 
            @RemainingamounttoinvestinAK AS 'RemainingamounttoinvestinAK';

-- ,@originVal as 'originVal'        

