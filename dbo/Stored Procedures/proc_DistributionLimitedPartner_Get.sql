-- [proc_DistributionLimitedPartner_Get] 1 

CREATE PROCEDURE [dbo].[proc_DistributionLimitedPartner_Get] @DistributionID INT
AS
    BEGIN
        SELECT
        (
            SELECT TOP 1 limitedpartnerid
            FROM tbl_LimitedPartner lp1
            WHERE lp1.ObjectID = lp.ObjectID
                  AND lp1.moduleid = lp.moduleid
            ORDER BY lp1.limitedpartnerid
        ) limitedpartnerid, 
        cc.distributionid, 
        ccal.fundid, 
        CAST(ccal.totalamount AS DECIMAL(18, 2)) AS CallAmount, 
        ccal.date AS CallDate, 
        (
            SELECT TOP 1(CASE
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
            FROM tbl_limitedpartner lp1
            WHERE lp1.ModuleID = lp.ModuleID
                  AND lp1.ObjectID = lp.ObjectID
        ) AS LimitedPartnerName, 
        lp.ObjectID LimitedPartnerObjectID, 
        STUFF(
        (
            SELECT '; ' + CAST(v.vehicleshareid AS VARCHAR(MAX)) + ',' + CAST(v.sharename AS VARCHAR(MAX)) [text()]
            FROM tbl_vehicleshare v
            WHERE v.vehicleid = ccal.fundid FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') FundShares, 
        STUFF(
        (
            SELECT '; ' + CAST(aaa.shareid AS VARCHAR(MAX)) + ',' + CAST(CAST(SUM(aaa.amount) AS DECIMAL(18, 2)) AS VARCHAR(50)) [text()]
            FROM tbl_distributionlimitedpartner aaa
                 JOIN tbl_LimitedPartner lp1 ON aaa.LimitedPartnerID = lp1.LimitedPartnerID
            WHERE aaa.distributionid = cc.distributionid
                  AND lp1.ObjectID = lp.ObjectID
                  AND lp1.ModuleID = lp.ModuleID
                  AND shareid <> 0
            GROUP BY aaa.shareid FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') LinkedInvestees, 
        STUFF(
        (
            SELECT '; ' + CAST(aaa.shareid AS VARCHAR(MAX)) + ',' + CAST(CAST(SUM(aaa.amount) AS DECIMAL(18, 2)) AS VARCHAR(50)) [text()]
            FROM tbl_distributionlimitedpartner aaa
            WHERE aaa.distributionid = cc.distributionid
                  AND shareid <> 0
            GROUP BY aaa.shareid FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') LinkedInvesteesTotal, 
        STUFF(
        (
            SELECT '; ' + CAST(innvs.sharename AS VARCHAR(MAX)) [text()]
            FROM tbl_vehicleshare innvs
            WHERE innvs.vehicleid = ccal.fundid FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesName, 
        STUFF(
        (
            SELECT '; ' + CAST(innvs.sharename AS VARCHAR(MAX)) + ',' + CAST(CAST(SUM(ISNULL(inncc.amount, 0)) AS DECIMAL(18, 2)) AS VARCHAR(MAX)) [text()]
            FROM tbl_distributionlimitedpartner inncc
                 JOIN tbl_vehicleshare innvs ON innvs.vehicleshareid = inncc.shareid
                 JOIN tbl_LimitedPartner lp1 ON lp1.LimitedPartnerID = inncc.LimitedPartnerID
            WHERE inncc.distributionid = @DistributionID
                  AND lp1.ModuleID = lp.ModuleID
                  AND lp1.ObjectID = lp.ObjectID
                  AND shareid <> 0
            GROUP BY inncc.shareid, 
                     innvs.sharename FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') AmountInEachShare, 
        (
            SELECT CAST(SUM(ISNULL(inncc.Amount, 0)) AS DECIMAL(18, 2))
            FROM tbl_distributionlimitedpartner inncc
                 JOIN tbl_LimitedPartner lp1 ON lp1.LimitedPartnerID = inncc.LimitedPartnerID
            WHERE inncc.distributionid = @DistributionID
                  AND lp1.ModuleID = lp.ModuleID
                  AND lp1.ObjectID = lp.ObjectID
                  AND shareid <> 0
        ) AS SharesTotal
        FROM tbl_distributionlimitedpartner cc
             JOIN tbl_distribution ccal ON cc.distributionid = ccal.distributionid
             JOIN tbl_limitedpartner lp ON lp.LimitedPartnerID = cc.LimitedPartnerID
        WHERE cc.distributionid = @DistributionID
        GROUP BY lp.ObjectID, 
                 lp.ModuleID, 
                 cc.distributionid, 
                 ccal.fundid, 
                 ccal.totalamount, 
                 ccal.date
        ORDER BY limitedpartnername;
    END;
