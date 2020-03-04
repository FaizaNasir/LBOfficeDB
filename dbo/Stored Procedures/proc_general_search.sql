--   
  
CREATE PROCEDURE [dbo].[proc_general_search]  
(@name     VARCHAR(100),   
 @userrole VARCHAR(100)  
)  
AS  
    BEGIN  
        SELECT TOP (CASE  
                        WHEN LEN(@name) < 3  
                        THEN 20  
                        ELSE 100  
                    END) dealid ObjectID,   
                         dealname ObjectName,   
                         'Deal' Type,   
                         6 ModuleID,   
                         DealCurrentTargetID CompanyID,   
                         NULL PortfolioID,   
                         NULL VehicleID,   
                         NULL VehicleParentID  
        FROM tbl_Deals  
        WHERE dealname LIKE '%' + @name + '%'  
              AND EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_tabspermission  
            WHERE moduleID = 6  
                  AND TabID IS NULL  
                  AND SubTabID IS NULL  
                  AND UserRole = @userrole  
                  AND IsRead = 1  
        )  
              AND NOT EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_BlockedPermission b  
            WHERE b.moduleName = 'Deals'  
                  AND UserRole = @userrole  
                  AND b.ObjectID = DealID  
        )  
              AND NOT EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_BlockedGroupPermission b  
            WHERE b.moduleID = 6  
                  AND UserRole = @userrole  
                  AND b.TypeID = DealTypeID  
        )  
        UNION ALL  
        SELECT TOP (CASE  
                        WHEN LEN(@name) < 3  
                        THEN 20  
                        ELSE 100  
                    END) companycontactid ObjectID,   
                         companyname ObjectName,   
                         'Company' Type,   
                         5 ModuleID,   
                         NULL CompanyID,   
                         NULL PortfolioID,   
                         NULL VehicleID,   
                         NULL VehicleParentID  
        FROM tbl_companycontact c  
        WHERE companyname LIKE '%' + @name + '%'  
              AND EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_tabspermission  
            WHERE moduleID = 5  
                  AND TabID IS NULL  
                  AND SubTabID IS NULL  
                  AND UserRole = @userrole  
                  AND IsRead = 1  
        )  
              AND NOT EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_BlockedPermission b  
            WHERE b.moduleName = 'Company'  
                  AND UserRole = @userrole  
                  AND b.ObjectID = CompanyContactID  
        )  
              AND NOT EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_BlockedGroupPermission b  
                 JOIN tbl_CompanyContactType cct ON b.TypeID = cct.ContactTypeID  
            WHERE b.moduleID = 5  
                  AND UserRole = @userrole  
                  AND cct.CompanyContactID = c.CompanyContactID  
        )  
        UNION ALL  
        SELECT TOP (CASE  
                        WHEN LEN(@name) < 3  
                        THEN 20  
                        ELSE 100  
                    END) Vehicleid ObjectID,   
                         name ObjectName,   
                         'Vehicle' Type,   
                         3 ModuleID,   
                         NULL CompanyID,   
                         NULL PortfolioID,   
                         NULL VehicleID,   
                         NULL VehicleParentID  
        FROM tbl_vehicle  
        WHERE name LIKE '%' + @name + '%'  
              AND (TypeID != 4  
                   OR TypeID != 6)  
              AND TypeID <> 4  
              AND EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_tabspermission  
            WHERE moduleID = 3  
                  AND TabID IS NULL  
                  AND SubTabID IS NULL  
                  AND UserRole = @userrole  
                  AND IsRead = 1  
        )  
         AND NOT EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_BlockedPermission b  
            WHERE b.moduleName = 'Funds'  
                  AND UserRole = @userrole  
                  AND b.ObjectID = VehicleID  
        )  
        UNION ALL  
        SELECT TOP (CASE  
                        WHEN LEN(@name) < 3  
                        THEN 20  
                        ELSE 100  
                    END) IndividualID ObjectID,   
                         individuallastname + ' ' + individualfirstname ObjectName,   
                         'Individual' Type,   
                         4 ModuleID,   
                         NULL CompanyID,   
                         NULL PortfolioID,   
                         NULL VehicleID,   
                         NULL VehicleParentID  
        FROM tbl_contactindividual c  
        WHERE individualfullname LIKE '%' + @name + '%'  
              AND EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_tabspermission  
            WHERE moduleID = 4  
                  AND TabID IS NULL  
                  AND SubTabID IS NULL  
                  AND UserRole = @userrole  
                  AND IsRead = 1  
        )  
              AND NOT EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_BlockedPermission b  
            WHERE b.moduleName = 'Contacts'  
                  AND UserRole = @userrole  
                  AND b.ObjectID = IndividualID  
        )  
              AND NOT EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_BlockedGroupPermission b  
                 JOIN tbl_ContactIndividualContactTypes cct ON b.TypeID = cct.ContactIndividualTypeID  
            WHERE b.moduleID = 4  
                  AND UserRole = @userrole  
                  AND cct.ContactIndividualID = c.IndividualID  
        )  
        UNION ALL  
        SELECT TOP (CASE  
                        WHEN LEN(@name) < 3  
                        THEN 20  
                        ELSE 100  
                    END) companycontactid ObjectID,   
                         companyname + ' (' + v.Name + ')' ObjectName,   
                         'Portfolio' Type,   
                         5 ModuleID,   
                         Companycontactid,   
                         p.PortfolioID,   
                         v.VehicleID,   
                         NULL VehicleParentID  
        FROM tbl_companycontact cc  
             JOIN tbl_portfolio p ON p.TargetPortfolioID = cc.CompanyContactID  
             JOIN tbl_PortfolioVehicle pv ON pv.portfolioid = p.portfolioid  
             JOIN tbl_vehicle v ON v.VehicleID = pv.VehicleID  
        WHERE companyname LIKE '%' + @name + '%'  
              AND EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_tabspermission  
            WHERE moduleID = 7  
                  AND TabID IS NULL  
                  AND SubTabID IS NULL  
                  AND UserRole = @userrole  
                  AND IsRead = 1  
        )  
              AND NOT EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_BlockedPermission b  
            WHERE b.moduleName = 'Portfolio'  
                  AND UserRole = @userrole  
                  AND b.ObjectID = p.PortfolioID  
        )  
        UNION ALL  
        SELECT TOP (CASE  
                        WHEN LEN(@name) < 3  
                        THEN 20  
                        ELSE 100  
                    END) companycontactid ObjectID,   
                         companyname + ' (' + v.Name + ')' ObjectName,   
                         'Portfolio' Type,   
                         5 ModuleID,   
                         Companycontactid,   
                         p.PortfolioID,   
                         v.VehicleID,   
                         NULL VehicleParentID  
        FROM tbl_companycontact cc  
             JOIN tbl_portfolio p ON p.TargetPortfolioID = cc.CompanyContactID  
             JOIN tbl_portfoliooptional po ON po.portfolioid = p.PortfolioID  
             JOIN tbl_PortfolioVehicle pv ON pv.portfolioid = p.portfolioid  
             JOIN tbl_vehicle v ON v.VehicleID = pv.VehicleID  
        WHERE Filename LIKE '%' + @name + '%'  
              AND EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_tabspermission  
            WHERE moduleID = 7  
                  AND TabID IS NULL  
                  AND SubTabID IS NULL  
                  AND UserRole = @userrole  
                  AND IsRead = 1  
        )  
              AND NOT EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_BlockedPermission b  
            WHERE b.moduleName = 'Portfolio'  
                  AND UserRole = @userrole  
                  AND b.ObjectID = p.PortfolioID  
        )  
        UNION ALL  
        SELECT TOP (CASE  
                        WHEN LEN(@name) < 3  
                        THEN 20  
                        ELSE 100  
                    END) v.Vehicleid ObjectID,   
                         v.name + ' (' + v2.Name + ')' ObjectName,   
                         'Portfolio Fund' Type,   
                         3 ModuleID,   
                         NULL CompanyID,   
                         NULL PortfolioID,   
                         NULL VehicleID,   
                         v2.VehicleID VehicleParentID  
        FROM tbl_VehiclePortfolioFund vpf  
             JOIN tbl_vehicle v ON v.VehicleID = vpf.portfolioFundID  
             JOIN tbl_vehicle v2 ON v2.VehicleID = vpf.VehicleID  
        WHERE v.Name LIKE '%' + @name + '%'  
              AND (v.TypeID = 4  
                   OR v.TypeID = 6)  
              AND EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_tabspermission  
            WHERE moduleID = 3  
                  AND TabID IS NULL  
                  AND SubTabID IS NULL  
                  AND UserRole = @userrole  
                  AND IsRead = 1  
        )  
              AND NOT EXISTS  
        (  
            SELECT TOP 1 1  
            FROM tbl_BlockedPermission b  
            WHERE b.moduleName = 'Funds'  
                  AND UserRole = @userrole  
                  AND b.ObjectID = v.VehicleID  
        );  
    END;    