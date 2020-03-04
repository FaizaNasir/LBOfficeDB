
-- exec [dbo].[proc_InvesteeCompany_ByVehicle_GET] @RoleID='Back Office',@VehicleID=86

CREATE PROCEDURE [dbo].[proc_InvesteeCompany_ByVehicle_GET] --1      
@RoleID    VARCHAR(MAX), 
@VehicleID INT          = NULL
AS
    BEGIN
        SELECT cc.CompanyContactID, 
               cc.Companyname
        FROM tbl_Portfolio p
             INNER JOIN tbl_PortfolioVehicle pv ON pv.PortfolioID = p.PortfolioID
             INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
        WHERE pv.VehicleID = ISNULL(@VehicleID, VehicleID)
              AND pv.PortfolioID NOT IN
        (
            SELECT b.ObjectID
            FROM tbl_BlockedPermission b
            WHERE b.moduleName = 'Portfolio'
                  AND UserRole = @RoleID
                  AND b.ObjectID = pv.PortfolioID
        )
              AND cc.CompanyContactID NOT IN
        (
            SELECT cct.CompanyContactID
            FROM tbl_BlockedGroupPermission b
                 JOIN tbl_CompanyContactType cct ON b.TypeID = cct.ContactTypeID
                                                    AND cct.CompanyContactID = cc.CompanyContactID
            WHERE b.moduleID = 5
                  AND UserRole = @RoleID
        )
        ORDER BY cc.Companyname ASC;
    END;
