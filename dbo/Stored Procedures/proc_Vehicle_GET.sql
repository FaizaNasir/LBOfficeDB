CREATE PROCEDURE [dbo].[proc_Vehicle_GET] @VehicleID INT          = NULL, 
                                          @RoleName  VARCHAR(100) = NULL
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
        (
            SELECT countryname
            FROM tbl_country c
            WHERE c.countryid = v.countryid
        ) CountryName, 
               V.[Notes], 
               V.[SubFundRatiobasedonCommitments], 
               V.[CreatedDateTime], 
               V.[CreatedBy], 
               V.[ModifiedDateTime], 
               V.[ModifiedBy], 
               V.[VintageYear], 
               CC.[CompanyName], 
               V.Role, 
               V.IsExit, 
               s.StateDesc AS 'StateName', 
               c.currencycode, 
               REPLACE(dbo.F_GetActivityName(V.VehicleID), ',', ',') AS 'ActivityName', 
        (
            SELECT ActiviteName
            FROM tbl_Activities a
            WHERE a.ActiviteID = v.MainActivity
        ) MainActivityName, 
               V.Active, 
               AssociatedVehicleID, 
        (
            SELECT cc.name
            FROM tbl_Vehicle cc
            WHERE cc.VehicleID = v.AssociatedVehicleID
        ) AssociatedVehicleName
        FROM tbl_Vehicle V
             LEFT OUTER JOIN tbl_currency c ON c.currencyid = V.CurrencyID
             LEFT JOIN tbl_CompanyContact CC ON V.ManagementCompanyID = CC.CompanyContactID
             LEFT OUTER JOIN tbl_State S ON V.StateID = s.StateID
        WHERE V.VehicleID = ISNULL(@VehicleID, V.VehicleID)
              AND V.VehicleID NOT IN
        (
            SELECT ModuleObjectID
            FROM tbl_ModuleObjectPermissions mbp
            WHERE mbp.noaccess = 1
                  AND mbp.ModuleName = 'Fund'
                  AND mbp.RoleID = @RoleName
        )

              --      AND EXISTS
              --(
              --    SELECT TOP 1 1
              --    FROM tbl_tabspermission
              --    WHERE moduleID = 3
              --          AND TabID IS NULL
              --          AND SubTabID IS NULL
              --          AND UserRole = @RoleName
              --          AND IsRead = 1
              --)

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
