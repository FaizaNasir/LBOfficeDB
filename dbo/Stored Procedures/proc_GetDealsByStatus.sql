CREATE PROC [dbo].[proc_GetDealsByStatus]
(@RoleID      VARCHAR(50), 
 @dealStageid INT, 
 @dealTypeid  INT         = NULL, 
 @officeID    INT, 
 @activityID  INT, 
 @vehicleID   INT
)
AS
    BEGIN
        IF @dealTypeid = -1
           OR @dealTypeid = 0
            SET @dealTypeid = NULL;
        IF @vehicleID = -1
           OR @vehicleID = 0
            SET @vehicleID = NULL;
        DECLARE @PortfolioTargetTypeID INT;
        SET @PortfolioTargetTypeID =
        (
            SELECT TOP 1 PortfolioTargetTypeID
            FROM tbl_Activities a
            WHERE a.ActiviteID = @activityID
        );
        IF @PortfolioTargetTypeID = 1
           OR @PortfolioTargetTypeID = 0
            BEGIN
                SELECT d.DealID, 
                       d.DealName, 
                       d.ReceivedDate, 
                       d.DealTypeID, 
                       d.DealSize, 
                       d.DealCurrencyCode, 
                       d.Notes, 
                       d.CreatedDateTime, 
                       d.ModifiedDateTime, 
                       c.companyName TargetName, 
                       c.CompanyContactID TargetID, 
                       ba.BusinessAreaTitle TargetDesc, 
                       ds.ProjectStatusTitle, 
                       p.CanView, 
                       d.dealStageid, 
                       d.ActivityID, 
                       dbo.[F_GetDealFund](d.DealID) LinkedFunds, 
                       dbo.[F_GetSponserFund](d.DealID) SponserFunds
                FROM tbl_deals(NOLOCK) d
                     LEFT JOIN tbl_companycontact c(NOLOCK) ON d.DealCurrentTargetID = c.CompanyContactID
                     LEFT JOIN tbl_BusinessArea(NOLOCK) ba ON c.CompanyBusinessAreaID = ba.BusinessAreaID
                     LEFT JOIN tbl_ModuleObjectPermissions(NOLOCK) AS P ON d.dealid = P.ModuleObjectID
                                                                           AND P.ModuleID = 6
                                                                           AND P.RoleID = @RoleID
                     LEFT JOIN tbl_DealStatus(NOLOCK) ds ON ds.ProjectStatusID = d.DealStatusID
                WHERE ISNULL(d.DealTypeID, 0) = ISNULL(@dealTypeid, ISNULL(d.DealTypeID, 0))
                      AND ISNULL(d.officeID, 0) = ISNULL(@officeID, ISNULL(d.officeID, 0))
                      AND d.dealStageid = @dealStageid
                      AND d.active = 1
                      AND p.CanView IS NULL
                      AND NOT EXISTS
                (
                    SELECT TOP 1 1
                    FROM tbl_DealOfficePermission ctp
                    WHERE ctp.RoleID = @RoleID
                          AND ctp.Officeid = d.officeID
                )
                      AND NOT EXISTS
                (
                    SELECT TOP 1 1
                    FROM tbl_BlockedPermission b
                    WHERE b.moduleName = 'Deals'
                          AND UserRole = @RoleID
                          AND b.ObjectID = DealID
                )
                      AND NOT EXISTS
                (
                    SELECT TOP 1 1
                    FROM tbl_BlockedGroupPermission b
                    WHERE b.moduleID = 6
                          AND UserRole = @RoleID
                          AND b.TypeID = DealTypeID
                )
                ORDER BY d.ReceivedDate DESC;
        END;
            ELSE
            IF @PortfolioTargetTypeID = 2
                BEGIN
                    SELECT d.DealID, 
                           d.DealName, 
                           d.ReceivedDate, 
                           d.DealTypeID, 
                           d.DealSize, 
                           d.DealCurrencyCode, 
                           d.Notes, 
                           d.CreatedDateTime, 
                           d.ModifiedDateTime, 
                           v.Name TargetName, 
                           v.VehicleID TargetID, 
                           '' TargetDesc, 
                           ds.ProjectStatusTitle, 
                           p.CanView, 
                           d.dealStageid, 
                           d.ActivityID, 
                           dbo.[F_GetSponserFund](d.DealID) SponserFunds
                    FROM tbl_deals(NOLOCK) d
                         LEFT JOIN tbl_vehicle v(NOLOCK) ON d.DealCurrentTargetID = v.VehicleID
                         JOIN tbl_dealvehicle dv(NOLOCK) ON d.DealId = dv.DealId
                         LEFT JOIN tbl_ModuleObjectPermissions(NOLOCK) AS P ON d.dealid = P.ModuleObjectID
                                                                               AND P.ModuleID = 6
                                                                               AND P.RoleID = @RoleID
                         LEFT JOIN tbl_DealStatus(NOLOCK) ds ON ds.ProjectStatusID = d.DealStatusID
                    WHERE ISNULL(dv.vehicleID, 0) = ISNULL(@vehicleID, ISNULL(dv.vehicleID, 0))
                          AND ISNULL(d.DealTypeID, 0) = ISNULL(@dealTypeid, ISNULL(d.DealTypeID, 0))
                          AND ISNULL(d.officeID, 0) = ISNULL(@officeID, ISNULL(d.officeID, 0))
                          AND d.dealStageid = @dealStageid
                          AND d.active = 1
                          AND p.CanView IS NULL
                          AND NOT EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_DealOfficePermission ctp
                        WHERE ctp.RoleID = @RoleID
                              AND ctp.Officeid = d.officeID
                    )
                          AND NOT EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_BlockedPermission b
                        WHERE b.moduleName = 'Deals'
                              AND UserRole = @RoleID
                              AND b.ObjectID = d.DealID
                    )
                          AND NOT EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_BlockedGroupPermission b
                        WHERE b.moduleID = 6
                              AND UserRole = @RoleID
                              AND b.TypeID = DealTypeID
                    )
                    ORDER BY d.ReceivedDate DESC;
            END;
    END;
