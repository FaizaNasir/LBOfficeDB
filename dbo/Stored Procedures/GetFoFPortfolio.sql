CREATE PROC [dbo].[GetFoFPortfolio](@date DATETIME)
AS
     IF @date IS NULL
         SET @date = '01/01/2400';
     SELECT v.Name PortfolioFund, 
            v.IsExit, 
            v.VehicleID, 
            pv.VehicleID ParentVehicleID, 
            pv.Name ParentVehicleName, 
            v.VintageYear, 
     (
         SELECT TOP 1 Date
         FROM tbl_PortfolioFundGeneralOperation a
         WHERE a.vehicleid = v.vehicleid
               AND a.Date <= @date
         ORDER BY a.date ASC
     ) SubscriptionDate,
            CASE
                WHEN v.TypeID = 6
                THEN
     (
         SELECT SUM(Amount)
         FROM tbl_LimitedPartnerDetail lpd
              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                            AND lp.VehicleID = v.VehicleID
     )
                ELSE v.Size
            END Size,
            CASE
                WHEN v.TypeID = 6
                THEN
     (
         SELECT SUM(Amount)
         FROM tbl_LimitedPartnerDetail lpd
              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                            AND lp.VehicleID = v.VehicleID
                                            AND lp.ModuleID = 3
                                            AND lp.ObjectID = pv.VehicleID
     )
                ELSE
     (
         SELECT SUM(Amount)
         FROM tbl_PortfolioFundGeneralOperation a
         WHERE a.vehicleid = v.vehicleid
               AND a.Date <= @date
               AND typeid = 1
     )
            END Commitments,
            CASE
                WHEN v.TypeID = 6
                THEN
     (
         SELECT SUM(Amount)
         FROM tbl_LimitedPartnerDetail lpd
              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
                                            AND lp.VehicleID = v.VehicleID
                                            AND lp.ModuleID = 3
                                            AND lp.ObjectID = pv.VehicleID
     )
                ELSE
     (
         SELECT SUM(ForeignCurrencyAmount)
         FROM tbl_PortfolioFundGeneralOperation a
         WHERE a.vehicleid = v.vehicleid
               AND a.Date <= @date
               AND typeid = 1
     )
            END CommitmentsFX, 
            dbo.F_GetActivityName(v.vehicleID) FundType, 
            c.CurrencyCode,
            CASE
                WHEN v.TypeID = 6
                THEN
     (
         SELECT SUM(Amount)
         FROM tbl_CapitalcallLimitedPartner lpd
              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
              JOIN tbl_CapitalCall c ON c.CapitalCallID = lpd.CapitalCallID
                                        AND lp.VehicleID = v.VehicleID
                                        AND c.FundID = v.VehicleID
                                        AND lp.ModuleID = 3
                                        AND lp.ObjectID = pv.VehicleID
     )
                ELSE
     (
         SELECT SUM(Amount)
         FROM tbl_PortfolioFundGeneralOperation a
         WHERE a.vehicleid = v.vehicleid
               AND a.Date <= @date
               AND typeid = 2
     )
            END CapitalCall,
            CASE
                WHEN v.TypeID = 6
                THEN
     (
         SELECT SUM(Amount)
         FROM tbl_CapitalcallLimitedPartner lpd
              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
              JOIN tbl_CapitalCall c ON c.CapitalCallID = lpd.CapitalCallID
                                        AND lp.VehicleID = v.VehicleID
                                        AND c.FundID = v.VehicleID
                                        AND lp.ModuleID = 3
                                        AND lp.ObjectID = pv.VehicleID
     )
                ELSE
     (
         SELECT SUM(ForeignCurrencyAmount)
         FROM tbl_PortfolioFundGeneralOperation a
         WHERE a.vehicleid = v.vehicleid
               AND a.Date <= @date
               AND typeid = 2
     )
            END CapitalCallFX,
            CASE
                WHEN v.TypeID = 6
                THEN
     (
         SELECT SUM(Amount)
         FROM tbl_DistributionLimitedPartner lpd
              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
              JOIN tbl_Distribution d ON d.DistributionID = lpd.DistributionID
                                         AND lp.VehicleID = v.VehicleID
                                         AND d.FundID = v.VehicleID
                                         AND lp.ModuleID = 3
                                         AND lp.ObjectID = pv.VehicleID
     )
                ELSE
     (
         SELECT SUM(Amount)
         FROM tbl_PortfolioFundGeneralOperation a
         WHERE a.vehicleid = v.vehicleid
               AND a.Date <= @date
               AND typeid = 3
     )
            END Distribution,
            CASE
                WHEN v.TypeID = 6
                THEN
     (
         SELECT SUM(Amount)
         FROM tbl_DistributionLimitedPartner lpd
              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = lpd.LimitedPartnerID
              JOIN tbl_Distribution d ON d.DistributionID = lpd.DistributionID
                                         AND lp.VehicleID = v.VehicleID
                                         AND d.FundID = v.VehicleID
                                         AND lp.ModuleID = 3
                                         AND lp.ObjectID = pv.VehicleID
     )
                ELSE
     (
         SELECT SUM(ForeignCurrencyAmount)
         FROM tbl_PortfolioFundGeneralOperation a
         WHERE a.vehicleid = v.vehicleid
               AND a.Date <= @date
               AND typeid = 3
     )
            END DistributionFX, 
     (
         SELECT SUM(Amount)
         FROM tbl_PortfolioFundGeneralOperation a
         WHERE a.vehicleid = v.vehicleid
               AND a.Date <= @date
               AND typeid = 4
     ) RecallableDistributions,
            CASE
                WHEN v.TypeID = 6
                THEN
     (
         SELECT SUM(Amount)
         FROM tbl_VehicleNavLimitedPartner a
              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = a.LimitedPartnerID
         WHERE a.VehicleNavID =
         (
             SELECT TOP 1 b.VehicleNavID
             FROM tbl_VehicleNav b
             WHERE b.VehicleID = v.VehicleID
                   AND b.NavDate <= @date
             ORDER BY b.NavDate DESC
         )
               AND lp.ObjectID = pv.VehicleID
               AND lp.ModuleID = 3
     )
                ELSE
     (
         SELECT TOP 1 CASE
                          WHEN v.CurrencyID <> 44
                          THEN a.NAV / ISNULL(
         (
             SELECT TOP 1 rate
             FROM tbl_MultiCurrencyRate rate
                  JOIN tbl_Currency c ON rate.CurrencyID = c.CurrencyCode
                                         AND c.CurrencyID = v.CurrencyID
             ORDER BY rate.Date DESC
         ), 1)
                          ELSE a.NAV * ISNULL(
         (
             SELECT TOP 1 rate
             FROM tbl_MultiCurrencyRate rate
                  JOIN tbl_Currency c ON rate.CurrencyID = c.CurrencyCode
                                         AND c.CurrencyID = v.CurrencyID
             ORDER BY rate.Date DESC
         ), 1)
                      END NAV
         FROM tbl_PortfolioFundNav a
         WHERE a.vehicleid = v.vehicleid
               AND a.Date <= @date
         ORDER BY Date DESC
     )
            END NAV, 
            v.TypeID,
            CASE
                WHEN v.TypeID = 6
                THEN
     (
         SELECT SUM(Amount)
         FROM tbl_VehicleNavLimitedPartner a
              JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = a.LimitedPartnerID
         WHERE a.VehicleNavID =
         (
             SELECT TOP 1 b.VehicleNavID
             FROM tbl_VehicleNav b
             WHERE b.VehicleID = v.VehicleID
                   AND b.NavDate <= @date
             ORDER BY b.NavDate DESC
         )
               AND lp.ObjectID = pv.VehicleID
               AND lp.ModuleID = 3
     )
                ELSE
     (
         SELECT TOP 1 a.NAV
         FROM tbl_PortfolioFundNav a
         WHERE a.vehicleid = v.vehicleid
               AND a.Date <= @date
         ORDER BY Date DESC
     )
            END NAVFX, 
            v.TargetGeography, 
            v.Role
     FROM tbl_vehicle v
          JOIN tbl_currency c ON c.currencyid = v.CurrencyID
          JOIN tbl_VehiclePortfolioFund vpf ON vpf.PortfolioFundID = v.VehicleID
          JOIN tbl_vehicle pv ON pv.VehicleID = vpf.VehicleID;
