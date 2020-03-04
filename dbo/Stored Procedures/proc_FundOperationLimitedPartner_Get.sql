-- exec [dbo].[proc_FundOperationLimitedPartner_Get] @VehicleID=8,@objectID=NULL,@moduleID=12

CREATE PROCEDURE [dbo].[proc_FundOperationLimitedPartner_Get] @VehicleID INT, 
                                                             @objectID  INT, 
                                                             @moduleID  INT
AS
    BEGIN
        IF @moduleID = 12
           OR @moduleID = 3
            SET @moduleID = NULL;
        SELECT DISTINCT 
               *, 
        (
            SELECT number
            FROM tbl_VehicleClosing vc
            WHERE vc.VehicleID = @VehicleID
                  AND CallDate BETWEEN vc.StartDate AND vc.EndDate
        ) Closing, 
        (
            SELECT name
            FROM tbl_vehicle v
            WHERE v.vehicleid = @vehicleid
        ) FundName
        FROM
        (
            SELECT ccal.LimitedPartnerID ID, 
                   CAST(SUM(ISNULL(cc.Amount, 0)) AS DECIMAL(18, 2)) AS Amount, 
                   ccal.Date AS CallDate, 
                   ccal.LimitedPartnerID FromLPID, 
                   (CASE
                        WHEN ccal.ModuleID = 4
                        THEN
            (
                SELECT TOP 1 CI.IndividualFullName
                FROM [tbl_ContactIndividual] CI
                WHERE CI.IndividualID = ccal.ObjectID
            )
                        WHEN ccal.ModuleID = 5
                        THEN
            (
                SELECT TOP 1 CC.CompanyName
                FROM [tbl_CompanyContact] CC
                WHERE CC.CompanyContactID = ccal.ObjectID
            )
                        WHEN ccal.ModuleID = 3
                        THEN
            (
                SELECT TOP 1 V.Name
                FROM [tbl_Vehicle] V
                WHERE V.VehicleID = ccal.ObjectID
            )
                    END) AS FromLP, 
                   ccal.ObjectID FromObjectID, 
                   ccal.ModuleID FromModuleID, 
                   NULL ToLPID, 
                   NULL ToLP, 
                   NULL ToObjectID, 
                   NULL ToModuleID, 
                   ccal.Notes, 
                   STUFF(
            (
                SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) [text()]
                FROM tbl_vehicleshare innvs
                WHERE innvs.VehicleID = @VehicleID FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesName, 
                   STUFF(
            (
                SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) + ',' + CAST(inncc.Amount AS VARCHAR(MAX)) [text()]
                FROM tbl_LimitedPartnerDetail inncc
                     JOIN tbl_LimitedPartner innccal ON inncc.LimitedPartnerID = innccal.LimitedPartnerID
                     JOIN tbl_vehicleshare innvs ON innvs.VehicleShareID = inncc.ShareID
                WHERE innccal.VehicleID = @VehicleID
                      AND innccal.ModuleID = ISNULL(@ModuleID, ccal.ModuleID)
                      AND innccal.ObjectID = ISNULL(@ObjectID, ccal.ObjectID)
                      AND inncc.LimitedPartnerID = ccal.LimitedPartnerID FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesBreakDown, 
                   'Commitment' Type
            FROM tbl_LimitedPartnerDetail cc
                 JOIN tbl_LimitedPartner ccal ON cc.LimitedPartnerID = ccal.LimitedPartnerID
            WHERE ccal.VehicleID = ISNULL(@VehicleID, ccal.VehicleID)
                  AND ccal.ModuleID = ISNULL(@ModuleID, ccal.ModuleID)
                  AND ccal.ObjectID = ISNULL(@ObjectID, ccal.ObjectID)

            --and 1=0

            GROUP BY ccal.ObjectID, 
                     ModuleID, 
                     ccal.Date, 
                     ccal.Notes, 
                     ccal.LimitedPartnerID
            UNION ALL
            SELECT t.CommitmentTransferID ID, 
                   CAST(SUM(ISNULL(Amount, 0)) AS DECIMAL(18, 2)) AS Amount, 
                   t.CallDate, 
                   FromLPID, 
                   FromLP, 
                   FromObjectID, 
                   FromModuleID, 
                   ToLPID, 
                   ToLP, 
                   ToObjectID, 
                   ToModuleID, 
                   Notes, 
                   SharesName, 
                   SharesBreakDown, 
                   'Transfer' Type
            FROM
            (
                SELECT ShareAmount Amount, 
                       cc.CommitmentTransferID, 
                       cc.Date AS CallDate, 
                       -1 FromLPID, 
                       (CASE
                            WHEN cc.FromModuleID = 4
                            THEN
                (
                    SELECT TOP 1 CI.IndividualFullName
                    FROM [tbl_ContactIndividual] CI
                    WHERE CI.IndividualID = cc.FromObjectID
                )
                            WHEN cc.FromModuleID = 5
                            THEN
                (
                    SELECT TOP 1 c.CompanyName
                    FROM [tbl_CompanyContact] c
                    WHERE c.CompanyContactID = cc.FromObjectID
                )
                            WHEN cc.FromModuleID = 3
                            THEN
                (
                    SELECT TOP 1 V.Name
                    FROM [tbl_Vehicle] V
                    WHERE V.VehicleID = cc.FromObjectID
                )
                        END) AS FromLP, 
                       cc.FromObjectID FromObjectID, 
                       cc.FromModuleID FromModuleID, 
                       -1 ToLPID, 
                       (CASE
                            WHEN cc.ToModuleID = 4
                            THEN
                (
                    SELECT TOP 1 CI.IndividualFullName
                    FROM [tbl_ContactIndividual] CI
                    WHERE CI.IndividualID = cc.ToObjectID
                )
                            WHEN cc.ToModuleID = 5
                            THEN
                (
                    SELECT TOP 1 c.CompanyName
                    FROM [tbl_CompanyContact] c
                    WHERE c.CompanyContactID = cc.ToObjectID
                )
                            WHEN cc.ToModuleID = 3
                            THEN
                (
                    SELECT TOP 1 V.Name
                    FROM [tbl_Vehicle] V
                    WHERE V.VehicleID = cc.ToObjectID
                )
                        END) AS ToLP, 
                       cc.ToObjectID ToObjectID, 
                       cc.ToModuleID ToModuleID, 
                       cc.Notes, 
                       STUFF(
                (
                    SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) [text()]
                    FROM tbl_vehicleshare innvs
                    WHERE innvs.VehicleID = @VehicleID FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesName, 
                       STUFF(
                (
                    SELECT '; ' + CAST(innvs.ShareName AS VARCHAR(MAX)) + ',' + CAST(inncc.ShareAmount AS VARCHAR(MAX)) [text()]
                    FROM tbl_CommitmentTransferFundShare inncc
                         JOIN tbl_CommitmentTransfer innccal ON inncc.CommitmentTransferID = innccal.CommitmentTransferID
                         JOIN tbl_vehicleshare innvs ON innvs.VehicleShareID = inncc.FundShareID
                    WHERE innccal.FundID = @VehicleID
                          AND innccal.FromModuleID = ISNULL(@ModuleID, cc.FromModuleID)
                          AND innccal.FromObjectID = ISNULL(@ObjectID, cc.FromObjectID)
                          AND inncc.CommitmentTransferID = innccal.CommitmentTransferID FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)'), 1, 2, ' ') SharesBreakDown
                FROM tbl_CommitmentTransfer cc
                     JOIN tbl_CommitmentTransferFundShare ccDetail ON cc.CommitmentTransferID = ccDetail.CommitmentTransferID
                WHERE cc.FundID = ISNULL(@VehicleID, cc.FundID)
                      AND ((cc.FromModuleID = ISNULL(@moduleID, cc.FromModuleID)
                            AND cc.FromObjectID = ISNULL(@objectID, cc.FromObjectID))
                           OR (cc.ToModuleID = ISNULL(@moduleID, cc.ToModuleID)
                               AND cc.ToObjectID = ISNULL(@objectID, cc.ToObjectID)))
            ) t
            GROUP BY t.CommitmentTransferID, 
                     CallDate, 
                     FromLPID, 
                     FromLP, 
                     FromObjectID, 
                     FromModuleID, 
                     ToLPID, 
                     ToLP, 
                     ToObjectID, 
                     ToModuleID, 
                     Notes, 
                     SharesName, 
                     SharesBreakDown
        ) t
        ORDER BY t.CallDate DESC;
    END;
