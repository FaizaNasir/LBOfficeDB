CREATE PROCEDURE [dbo].[Getvehiclenavlimitedpartner] @VehicleNavID INT
AS
    BEGIN
        SELECT DISTINCT
        (
            SELECT TOP 1 limitedpartnerid
            FROM tbl_limitedpartner lp1
            WHERE lp1.objectID = lp.objectID
                  AND lp1.moduleID = lp.ModuleID
                  AND lp1.vehicleID = lp.VehicleID
        ) limitedpartnerid, 
        lp.ObjectID, 
        lp.ModuleID, 
        cc.vehiclenavid, 
        ccal.vehicleid, 
        (
            SELECT ISNULL(portfolionav, 0) + ISNULL(workingcapital, 0) + ISNULL(cash, 0) + ISNULL(other, 0)
            FROM tbl_vehiclenav vn
            WHERE vn.vehiclenavid = @VehicleNavID
        ) AS CallAmount, 
        ccal.navdate AS CallDate, 
        (
            SELECT TOP 1(CASE
                             WHEN lp1.moduleid = 4
                             THEN
            (
                SELECT TOP 1 CI.individualfullname
                FROM [tbl_contactindividual] CI
                WHERE CI.individualid = lp1.objectid
            )
                             WHEN lp1.moduleid = 5
                             THEN
            (
                SELECT TOP 1 CC.companyname
                FROM [tbl_companycontact] CC
                WHERE CC.companycontactid = lp1.objectid
            )
                         END)
            FROM tbl_limitedpartner lp1
            WHERE lp1.objectid = lp.objectid
                  AND lp1.moduleID = lp.moduleID
                  AND lp1.vehicleID = lp.vehicleid
        ) AS LimitedPartnerName, 
        STUFF(
        (
            SELECT '; ' + CAST(v.vehicleshareid AS VARCHAR(MAX)) + ',' + CAST(v.sharename AS VARCHAR(MAX)) [text()]
            FROM tbl_vehicleshare v
            WHERE v.vehicleid =
            (
                SELECT TOP 1 ccall.vehicleid
                FROM tbl_vehiclenav ccall
                WHERE ccall.vehiclenavid = @VehicleNavID
            ) FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') FundShares, 
        STUFF(
        (
            SELECT '; ' + CAST(aaa.shareid AS VARCHAR(MAX)) + ',' + CAST(SUM(CAST(aaa.amount AS DECIMAL(18, 2))) AS VARCHAR(50)) [text()]
            FROM tbl_vehiclenavlimitedpartner aaa
                 JOIN tbl_limitedpartner lp1 ON lp1.limitedpartnerid = aaa.limitedpartnerid
            WHERE aaa.vehiclenavid = cc.vehiclenavid
                  AND lp1.objectID = lp.objectID
                  AND lp1.ModuleID = lp.ModuleID
                  AND lp1.VehicleID = lp.VehicleID
            GROUP BY aaa.shareid FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') LinkedInvestees, 
        STUFF(
        (
            SELECT '; ' + CAST(aaa.shareid AS VARCHAR(MAX)) + ',' + CAST(CAST(SUM(aaa.amount) AS DECIMAL(18, 2)) AS VARCHAR(50)) [text()]
            FROM tbl_vehiclenavlimitedpartner aaa
            WHERE aaa.vehiclenavid = cc.vehiclenavid
            GROUP BY aaa.shareid FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') LinkedInvesteesTotal, 
        STUFF(
        (
            SELECT '; ' + CAST(innvs.sharename AS VARCHAR(MAX)) [text()]
            FROM tbl_vehicleshare innvs
            WHERE innvs.vehicleid = ccal.vehicleid FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesName, 
        STUFF(
        (
            SELECT '; ' + CAST(innvs.sharename AS VARCHAR(MAX)) + ',' + CAST(CAST(SUM(ISNULL(inncc.amount, 0)) AS DECIMAL(18, 2)) AS VARCHAR(MAX)) [text()]
            FROM tbl_vehiclenavlimitedpartner inncc
                 JOIN tbl_vehicleshare innvs ON innvs.vehicleshareid = inncc.shareid
                 JOIN tbl_limitedpartner lp1 ON lp1.limitedpartnerid = inncc.limitedpartnerid
            WHERE inncc.vehiclenavid = @VehicleNavID
                  AND lp1.objectID = lp.objectID
                  AND lp1.ModuleID = lp.ModuleID
                  AND lp1.VehicleID = lp.VehicleID
            GROUP BY inncc.shareid, 
                     innvs.sharename FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') AmountInEachShare, 
        (
            SELECT CAST(SUM(ISNULL(inncc.Amount, 0)) AS DECIMAL(18, 2))
            FROM tbl_vehiclenavlimitedpartner inncc
                 JOIN tbl_limitedpartner lp1 ON lp1.limitedpartnerid = inncc.limitedpartnerid
            WHERE inncc.vehiclenavid = @VehicleNavID
                  AND lp1.objectID = lp.objectID
                  AND lp1.ModuleID = lp.ModuleID
                  AND lp1.VehicleID = lp.VehicleID
        ) AS SharesTotal, 
        (
            SELECT TOP 1 lp.ObjectID
            FROM tbl_limitedpartner lp
            WHERE lp.limitedpartnerid = cc.limitedpartnerid
        ) AS LimitedPartnerObjectID
        FROM tbl_vehiclenavlimitedpartner cc
             JOIN tbl_vehiclenav ccal ON cc.vehiclenavid = ccal.vehiclenavid
             LEFT JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = cc.LimitedPartnerID
        WHERE cc.vehiclenavid = @VehicleNavID
        GROUP BY cc.vehiclenavid, 
                 ccal.vehicleid, 
                 ccal.navdate, 
                 lp.ObjectID, 
                 lp.VehicleID, 
                 lp.ModuleID, 
                 cc.limitedpartnerID
        ORDER BY limitedpartnername;
    END;
