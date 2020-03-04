CREATE PROCEDURE [dbo].[GetCASReportDetail] @VehicleNavID INT
AS
    BEGIN
        SELECT DISTINCT
        (
            SELECT name
            FROM tbl_vehicle v
            WHERE v.vehicleid = ccal.vehicleid
        ) VehicleName, 
        cc.VehicleNavLimitedPartnerID, 
        cc.ShareID, 
        s.ShareName, 
        s.ShareNameFr, 
        lp.ModuleID, 
        lp.ObjectID, 
        cc.limitedpartnerid, 
        cc.vehiclenavid, 
        ccal.vehicleid, 
        (
            SELECT ISNULL(portfolionav, 0) + ISNULL(workingcapital, 0) + ISNULL(cash, 0) + ISNULL(other, 0)
            FROM tbl_vehiclenav vn
            WHERE vn.vehiclenavid = @VehicleNavID
        ) AS CallAmount, 
        ccal.navdate AS CallDate, 
        (
            SELECT(CASE
                       WHEN lp.moduleid = 4
                       THEN
            (
                SELECT TOP 1 CI.individualfullname
                FROM [tbl_contactindividual] CI
                WHERE CI.individualid = lp.objectid
            )
                       WHEN lp.moduleid = 5
                       THEN
            (
                SELECT TOP 1 CC.companyname
                FROM [tbl_companycontact] CC
                WHERE CC.companycontactid = lp.objectid
            )
                       WHEN lp.moduleid = 3
                       THEN
            (
                SELECT TOP 1 V.Name
                FROM [tbl_Vehicle] V
                WHERE V.VehicleID = lp.objectid
            )
                   END)
            FROM tbl_limitedpartner lp
            WHERE lp.limitedpartnerid = cc.limitedpartnerid
        ) AS LimitedPartnerName, 
        (
            SELECT TOP 1 lp.ObjectID
            FROM tbl_limitedpartner lp
            WHERE lp.limitedpartnerid = cc.limitedpartnerid
        ) AS LimitedPartnerObjectID, 
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
            SELECT '; ' + CAST(aaa.shareid AS VARCHAR(MAX)) + ',' + CAST(CAST(aaa.amount AS DECIMAL(18, 2)) AS VARCHAR(50)) [text()]
            FROM tbl_vehiclenavlimitedpartner aaa
            WHERE aaa.vehiclenavid = cc.vehiclenavid
                  AND aaa.limitedpartnerid = cc.limitedpartnerid FOR XML PATH(''), TYPE
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
            WHERE inncc.vehiclenavid = @VehicleNavID
                  AND inncc.limitedpartnerid = cc.limitedpartnerid
            GROUP BY inncc.shareid, 
                     innvs.sharename FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') AmountInEachShare, 
        (
            SELECT CAST(SUM(ISNULL(inncc.Amount, 0)) AS DECIMAL(18, 2))
            FROM tbl_vehiclenavlimitedpartner inncc
            WHERE inncc.vehiclenavid = @VehicleNavID
                  AND inncc.LimitedPartnerID = cc.LimitedPartnerID
        ) AS SharesTotal
        FROM tbl_vehiclenavlimitedpartner cc
             JOIN tbl_vehiclenav ccal ON cc.vehiclenavid = ccal.vehiclenavid
             JOIN tbl_vehicleshare s ON s.VehicleShareID = cc.ShareID
             LEFT JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = cc.LimitedPartnerID
        WHERE cc.vehiclenavid = @VehicleNavID

        --AND cc.amount > 0

        GROUP BY cc.limitedpartnerid, 
                 cc.vehiclenavid, 
                 ccal.vehicleid, 
                 ccal.navdate, 
                 lp.ObjectID, 
                 lp.ModuleID, 
                 cc.VehicleNavLimitedPartnerID, 
                 cc.ShareID, 
                 s.ShareName, 
                 s.ShareNameFr
        ORDER BY limitedpartnername;
    END;
