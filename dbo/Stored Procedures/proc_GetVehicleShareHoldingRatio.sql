
-- proc_GetVehicleShareHoldingRatio 32    

CREATE PROCEDURE [dbo].[proc_GetVehicleShareHoldingRatio](@vehicleID INT)
AS
    BEGIN
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
        SET @RatioPrinciple =
        (
            SELECT SUM(Amount)
            FROM @sho
            WHERE FromTypeID <> 3
        ) - @totalamountofordinarybond - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 1, NULL), 0);
        SET @RatioCapital =
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
        ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 2, @vehicleID), 0);
        SET @Ratio5Year =
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
        ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 3, @vehicleID), 0);
        SET @Ratio8Year =
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
        ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 4, @vehicleID), 0);
        SET @RatioReglemente =
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
        ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 5, @vehicleID), 0);
        SET @RatioNonRelemente =
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
        ), 0) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, NULL, 6, @vehicleID), 0);
        SET @RatioCapitalIncrease =
        (
            SELECT SUM(Amount)
            FROM @sho
            WHERE FromID = -1
                  AND natureID = 1
        ) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, 1, 7, @vehicleID), 0);
        SET @RatioConvertibaleBonds =
        (
            SELECT SUM(Amount)
            FROM @sho
            WHERE FromTypeID <> 3
                  AND natureID = 2
        ) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, 2, 8, @vehicleID), 0);
        SET @RatioTransferSecurity =
        (
            SELECT SUM(Amount)
            FROM @sho
            WHERE FromTypeID <> 3
                  AND natureID = 3
        ) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, 3, 9, @vehicleID), 0);
        SET @RatioCurrentAccount =
        (
            SELECT SUM(Amount)
            FROM @sho
            WHERE FromTypeID <> 3
                  AND natureID = 4
        ) - ISNULL(dbo.[F_Sho_GetCostOfSoldInvs_Updated](@sho, NULL, 4, 10, @vehicleID), 0);
        SELECT ISNULL(@RatioPrinciple, 0) RatioPrinciple, 
               ISNULL(@RatioCapital, 0) RatioCapital, 
               ISNULL(@Ratio5Year, 0) Ratio5Year, 
               ISNULL(@Ratio8Year, 0) Ratio8Year, 
               ISNULL(@RatioReglemente, 0) RatioReglemente, 
               ISNULL(@RatioNonRelemente, 0) RatioNonRelemente, 
               ISNULL(@RatioCapitalIncrease, 0) RatioCapitalIncrease, 
               ISNULL(@RatioConvertibaleBonds, 0) RatioConvertibaleBonds, 
               ISNULL(@RatioTransferSecurity, 0) RatioTransferSecurity, 
               ISNULL(@RatioCurrentAccount, 0) RatioCurrentAccount, 
               ISNULL(@RatioRegion, 0) RatioRegion;
    END;
