CREATE PROCEDURE [dbo].[proc_Vehicle_GET_Funds_Live] @VehicleID INT          = NULL, 
                                                    @RoleName  VARCHAR(100) = NULL, 
                                                    @date      DATETIME
AS
    BEGIN
        SELECT V.[VehicleID], 
               V.[ManagementCompanyID], 
               V.[TypeID], 
               V.[Name], 
               V.[MainActivity], 
               V.[Size], 
               V.[CurrencyID], 
               V.[FormationOn], 
               V.[FundAddress], 
               V.[ZipCode], 
               V.[City], 
               V.[StateID], 
               V.[CountryID], 
               V.[Notes], 
               V.[SubFundRatiobasedonCommitments], 
               V.[CreatedDateTime], 
               V.[CreatedBy], 
               V.[ModifiedDateTime], 
               V.[ModifiedBy], 
               V.[VintageYear], 
               V.IsExit, 
               CC.[CompanyName], 
               s.StateDesc AS 'StateName', 
               c.currencycode, 
               REPLACE(dbo.F_GetActivityName(V.VehicleID), ',', ',') AS 'ActivityName', 
        (
            SELECT ActiviteName
            FROM tbl_Activities a
            WHERE a.ActiviteID = v.MainActivity
        ) MainActivityName, 
               V.Active, 
        (
            SELECT SUM(pgo.Amount)
            FROM tbl_PortfolioFundGeneralOperation pgo
            WHERE pgo.VehicleID = V.VehicleID
                  AND pgo.TypeID = 1
                  AND pgo.FromID = @VehicleID
                  AND date <= @date
                  AND pgo.ToID = V.VehicleID
        ) Commitment, 
        (
            SELECT SUM(pgo.Amount)
            FROM tbl_PortfolioFundGeneralOperation pgo
            WHERE pgo.VehicleID = V.VehicleID
                  AND pgo.TypeID = 2
                  AND pgo.FromID = @VehicleID
                  AND pgo.ToID = V.VehicleID
                  AND date <= @date
        ) Drawdown, 
        (
            SELECT SUM(pgo.Amount)
            FROM tbl_PortfolioFundGeneralOperation pgo
            WHERE pgo.VehicleID = V.VehicleID
                  AND pgo.TypeID = 3
                  AND pgo.FromID = V.VehicleID
                  AND pgo.ToID = @VehicleID
                  AND date <= @date
        ) Distribution, 
        (
            SELECT TOP 1 na.NAV
            FROM tbl_PortfolioFundNav na
            WHERE na.VehicleID = V.VehicleID
                  AND na.VehicleUnderManagmentID = @VehicleID
                  AND date <= @date
            ORDER BY na.Date DESC
        ) NAV, 
        (
            SELECT TOP 1 na.Unfunded
            FROM tbl_PortfolioFundNav na
            WHERE na.VehicleID = V.VehicleID
                  AND date <= @date
                  AND na.VehicleUnderManagmentID = @VehicleID
            ORDER BY na.Date DESC
        ) Unfunded
        FROM tbl_Vehicle V
             LEFT OUTER JOIN tbl_currency c ON c.currencyid = V.CurrencyID
             LEFT JOIN tbl_CompanyContact CC ON V.ManagementCompanyID = CC.CompanyContactID
             LEFT OUTER JOIN tbl_State S ON V.StateID = s.StateID
        WHERE V.VehicleID IN
        (
            SELECT PortfolioFundID
            FROM tbl_VehiclePortfolioFund
            WHERE VehicleID = ISNULL(@VehicleID, V.VehicleID)
        )
              AND V.VehicleID NOT IN
        (
            SELECT ModuleObjectID
            FROM tbl_ModuleObjectPermissions mbp
            WHERE mbp.noaccess = 1
                  AND mbp.ModuleName = 'Fund'
                  AND mbp.RoleID = @RoleName
        )
              AND (TypeID = 6
                   OR TypeID = 4) --FundUnderAdministrationAndPortfolioFund or PortfolioFund (see enum PortfolioTargetTypeID in constants.cs)

              AND NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_BlockedPermission b
            WHERE b.moduleName = 'Funds'
                  AND UserRole = @RoleName
                  AND b.ObjectID = VehicleID
        )
        ORDER BY Name;
    END;
