CREATE PROCEDURE [dbo].[proc_CapitalCallLimitedPartner_Get] @CapitalCallID INT
AS
    BEGIN
        SELECT *
        FROM
        (
            SELECT DISTINCT
            (
                SELECT TOP 1 LimitedPartnerID
                FROM tbl_LimitedPartner lp1
                WHERE lp1.ObjectID = lp.ObjectID
                      AND lp1.ModuleID = lp.ModuleID
            ) LimitedPartnerID, 
            lp.ModuleID, 
            lp.ObjectID, 
            cc.CapitalCallID, 
            ccal.FundID, 
            CAST(ccal.TotalAmount AS DECIMAL(18, 10)) AS CallAmount, 
            ccal.DueDate AS CallDate, 
            (
                SELECT(CASE
                           WHEN lp.ModuleID = 3
                           THEN
                (
                    SELECT TOP 1 VE.Name
                    FROM [tbl_Vehicle] VE
                    WHERE VE.VehicleID = lp.ObjectID
                )
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
                WHERE v.VehicleID = ccal.FundID FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') FundShares, 
            STUFF(
            (
                SELECT '; ' + CAST(ShareID AS VARCHAR(MAX)) + ',' + CAST(CAST(ISNULL(Amount, 0) AS DECIMAL(18, 10)) AS VARCHAR(50)) [text()]
                FROM
                (
                    SELECT ShareID, 
                           SUM(Amount) Amount
                    FROM tbl_CapitalCallLimitedPartner aaa
                         JOIN tbl_LimitedPartner lp1 ON lp1.LimitedPartnerID = aaa.LimitedPartnerID
                    WHERE aaa.CapitalCallID = cc.CapitalCallID
                          AND lp1.ModuleID = lp.ModuleID
                          AND lp1.ObjectID = lp.ObjectID
                    GROUP BY ShareID
                ) t FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') LinkedInvestees, 
            STUFF(
            (
                SELECT '; ' + CAST(aaa.ShareID AS VARCHAR(MAX)) + ',' + CAST(CAST(SUM(ISNULL(aaa.Amount, 0)) AS DECIMAL(18, 10)) AS VARCHAR(50)) [text()]
                FROM tbl_CapitalCallLimitedPartner aaa
                     JOIN tbl_LimitedPartner lp1 ON lp1.LimitedPartnerID = aaa.LimitedPartnerID
                WHERE aaa.CapitalCallID = cc.CapitalCallID
                      AND lp1.ModuleID = lp.ModuleID
                      AND lp1.ObjectID = lp.ObjectID
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
                SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) + ',' + CAST(CAST(SUM(ISNULL(inncc.Amount, 0)) AS DECIMAL(18, 10)) AS VARCHAR(MAX)) [text()]
                FROM tbl_CapitalCallLimitedPartner inncc
                     JOIN tbl_vehicleshare innvs ON innvs.VehicleShareID = inncc.ShareID
                     JOIN tbl_LimitedPartner lp1 ON lp1.LimitedPartnerID = inncc.LimitedPartnerID
                WHERE inncc.CapitalCallID = @CapitalCallID
                      AND lp1.ModuleID = lp.ModuleID
                      AND lp1.ObjectID = lp.ObjectID
                GROUP BY inncc.ShareID, 
                         innvs.ShareName FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') AmountInEachShare, 
            (
                SELECT CAST(SUM(ISNULL(inncc.Amount, 0)) AS DECIMAL(18, 10))
                FROM tbl_CapitalCallLimitedPartner inncc
                     JOIN tbl_LimitedPartner lp1 ON lp1.LimitedPartnerID = inncc.LimitedPartnerID
                WHERE inncc.CapitalCallID = @CapitalCallID
                      AND lp1.ModuleID = lp.ModuleID
                      AND lp1.ObjectID = lp.ObjectID
            ) AS SharesTotal
            FROM tbl_capitalcall ccal
                 LEFT JOIN tbl_CapitalCallLimitedPartner cc ON cc.CapitalCallID = ccal.CapitalCallID
                 LEFT JOIN tbl_LimitedPartner lp ON cc.LimitedPartnerID = lp.LimitedPartnerID

            --and lp.VehicleID = ccal.fundid

            WHERE ccal.CapitalCallID = @CapitalCallID
            GROUP BY lp.ModuleID, 
                     cc.LimitedPartnerID, 
                     lp.ObjectID, 
                     cc.CapitalCallID, 
                     ccal.FundID, 
                     ccal.TotalAmount, 
                     ccal.DueDate
        ) t
        WHERE LimitedPartnerID IS NOT NULL
        ORDER BY LimitedPartnerName;
    END;
