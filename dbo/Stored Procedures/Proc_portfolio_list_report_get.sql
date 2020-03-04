CREATE PROCEDURE [dbo].[Proc_portfolio_list_report_get](@VehicleID AS VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @tblVehicle AS TABLE(vehicleid VARCHAR(10));
        IF ISNULL(@VehicleID, '') = ''
            BEGIN
                INSERT INTO @tblVehicle
                       SELECT vehicleid
                       FROM tbl_vehicle;
        END;
            ELSE
            BEGIN
                INSERT INTO @tblVehicle
                       SELECT value
                       FROM dbo.Fnsplit(@VehicleID, ',');
        END;
        DECLARE @temp1 TABLE
        (vehicleID   INT, 
         companyid   INT, 
         companyname VARCHAR(100), 
         portfolioid INT
        );
        DECLARE @temp2 TABLE
        (companyid   INT, 
         companyname VARCHAR(100), 
         portfolioid INT
        );
        INSERT INTO @temp1
               SELECT DISTINCT 
                      vehicleID, 
                      p.targetportfolioid, 
                      c.companyname, 
                      p.portfolioid
               FROM tbl_portfoliovehicle pv
                    JOIN tbl_portfolio p ON pv.portfolioid = p.portfolioid
                    JOIN tbl_companycontact c ON c.companycontactid = p.targetportfolioid
               WHERE vehicleid IN
               (
                   SELECT *
                   FROM @tblVehicle
               )
                     AND STATUS IN(1, 2, 3);
        INSERT INTO @temp2
               SELECT DISTINCT 
                      s.objectid, 
                      c.companyname, 
                      p.portfolioid
               FROM tbl_shareholders S
                    INNER JOIN tbl_portfolio p ON p.targetportfolioid = s.objectid
                    INNER JOIN tbl_portfoliovehicle pv ON pv.portfolioid = p.portfolioid
                    INNER JOIN tbl_companycontact c ON c.companycontactid = s.objectid
               WHERE s.moduleid = 5
                     AND vehicleid IN
               (
                   SELECT *
                   FROM @tblVehicle
               )
                     AND STATUS IN(1, 2, 3);
        SELECT DISTINCT 
               t1.vehicleID, 
               t1.portfolioid, 
               t1.companyid AS 'CompanyContactID', 
               t1.companyname 'ComapanyName'--, 
        --b.BusinessAreaTitle 'Sector' 
        FROM @temp1 t1
             JOIN tbl_shareholders S ON t1.companyid = s.targetportfolioid
                                        AND s.moduleid = 5
             JOIN tbl_companycontact c ON c.companycontactid = t1.companyid
             LEFT JOIN tbl_businessarea b ON c.companybusinessareaid = b.businessareaid
        WHERE s.objectid NOT IN
        (
            SELECT companyid
            FROM @temp2
        )
        UNION ALL
        SELECT t.vehicleID, 
               t.portfolioid, 
               t.companyid AS 'CompanyContactID', 
               t.companyname 'ComapanyName'--, 
        --b.BusinessAreaTitle 'Sector' 
        FROM @temp1 t
             JOIN tbl_companycontact c ON c.companycontactid = t.companyid
             LEFT JOIN tbl_businessarea b ON c.companybusinessareaid = b.businessareaid
        WHERE t.companyid NOT IN
        (
            SELECT DISTINCT 
                   s.targetportfolioid
            FROM @temp1 t1
                 JOIN tbl_shareholders S ON t1.companyid = s.targetportfolioid
                                            AND s.moduleid = 5
        )
        ORDER BY t1.companyname;
        SET NOCOUNT OFF;
    END;
