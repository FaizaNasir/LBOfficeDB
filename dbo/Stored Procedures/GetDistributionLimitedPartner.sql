
-- [GetDistributionLimitedPartner] 7

CREATE PROCEDURE [dbo].[GetDistributionLimitedPartner] @DistributionID INT
AS
    BEGIN

        --select * from tbl_VehicleNavLimitedPartner

        SELECT DISTINCT 
               cc.LimitedPartnerID, 
               cc.DistributionID, 
               ccal.FundID AS VehicleID, 
        (
            SELECT TotalAmount
            FROM tbl_Distribution vn
            WHERE vn.DistributionID = @DistributionID
        ) AS CallAmount, --CAST(cc.Amount as decimal(18,2))  as CallAmount

               ccal.Date AS CallDate, 
        (
            SELECT(CASE
                       WHEN lp.ModuleID = 4
                       THEN
            (
                SELECT TOP 1 CI.IndividualFullName
                FROM [tbl_ContactIndividual] CI
                WHERE CI.IndividualID = lp.ObjectID
            )
                       WHEN lp.ModuleID = 5
                       THEN
            (
                SELECT TOP 1 CC.CompanyName
                FROM [tbl_CompanyContact] CC
                WHERE CC.CompanyContactID = lp.ObjectID
            )
                   END)
            FROM tbl_LimitedPartner lp
            WHERE lp.LimitedPartnerID = cc.LimitedPartnerID
        ) AS LimitedPartnerName, 
               STUFF(
        (
            SELECT '; ' + CAST(v.VehicleShareID AS VARCHAR(MAX)) + ',' + CAST(v.ShareName AS VARCHAR(MAX)) [text()]
            FROM tbl_vehicleshare v
            WHERE v.VehicleID =
            (
                SELECT TOP 1 ccall.FundID
                FROM tbl_Distribution ccall
                WHERE ccall.DistributionID = @DistributionID
            ) FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') FundShares, 
               STUFF(
        (
            SELECT '; ' + CAST(aaa.ShareID AS VARCHAR(MAX)) + ',' + CAST(CAST(aaa.Amount AS DECIMAL(18, 2)) AS VARCHAR(50)) [text()]
            FROM tbl_DistributionLimitedPartner aaa
            WHERE aaa.DistributionID = cc.DistributionID
                  AND aaa.LimitedPartnerID = cc.LimitedPartnerID FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') LinkedInvestees, 
               STUFF(
        (
            SELECT '; ' + CAST(aaa.ShareID AS VARCHAR(MAX)) + ',' + CAST(CAST(SUM(aaa.Amount) AS DECIMAL(18, 2)) AS VARCHAR(50)) [text()]
            FROM tbl_DistributionLimitedPartner aaa
            WHERE aaa.DistributionID = cc.DistributionID
            GROUP BY aaa.ShareID FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') LinkedInvesteesTotal, 
               STUFF(
        (
            SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) [text()]
            FROM tbl_vehicleshare innvs
            WHERE innvs.VehicleID = ccal.FundID FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesName, 
               STUFF(
        (
            SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) + ',' + CAST(CAST(SUM(ISNULL(inncc.Amount, 0)) AS FLOAT) AS VARCHAR(MAX)) [text()]
            FROM tbl_DistributionLimitedPartner inncc
                 JOIN tbl_vehicleshare innvs ON innvs.VehicleShareID = inncc.ShareID
            WHERE inncc.DistributionID = @DistributionID
                  AND inncc.LimitedPartnerID = cc.LimitedPartnerID
            GROUP BY inncc.ShareID, 
                     innvs.ShareName FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') AmountInEachShare
        FROM tbl_DistributionLimitedPartner cc
             JOIN tbl_Distribution ccal ON cc.DistributionID = ccal.DistributionID
        WHERE cc.DistributionID = @DistributionID
        GROUP BY cc.LimitedPartnerID, 
                 cc.DistributionID, 
                 ccal.FundID, 
                 ccal.Date;

        --select * from tbl_VehicleNavLimitedPartner cc where cc.VehicleNavID=7

    END;
