CREATE PROC [dbo].[proc_GetdealsSearch]
(@RoleID             VARCHAR(50), 
 @dealstatusid       VARCHAR(500), 
 @dealstageid        VARCHAR(500), 
 @dealSectorid       VARCHAR(500), 
 @dealTypeid         VARCHAR(500), 
 @freeText           VARCHAR(1000), 
 @startDate          DATETIME, 
 @endDate            DATETIME, 
 @dealSizeFrom       DECIMAL(18, 2), 
 @dealSizeTo         DECIMAL(18, 2), 
 @MCTeamMembers      VARCHAR(1000), 
 @senderIndividual   VARCHAR(1000), 
 @senderCompany      VARCHAR(1000), 
 @fundID             VARCHAR(1000), 
 @Character          VARCHAR(10), 
 @dealStatusCriteria VARCHAR(1000)  = NULL, 
 @dealStatusOccured  VARCHAR(500)   = NULL, 
 @index              INT, 
 @page               INT
)
AS
    BEGIN
        IF @dealSectorid = ''
            SET @dealSectorid = NULL;
        IF @senderIndividual = ''
            SET @senderIndividual = NULL;
        IF @senderCompany = ''
            SET @senderCompany = NULL;
        IF @dealTypeid = ''
            SET @dealTypeid = NULL;
        IF @Character IS NULL
            SET @Character = '%';
            ELSE
            SET @Character = @Character + '%';
        IF @MCTeamMembers = ''
            SET @MCTeamMembers = NULL;
        IF @fundID = ''
            SET @fundID = NULL;
        IF @dealstatusid = ''
            SET @dealstatusid = NULL;
        IF @dealstageid = ''
            SET @dealstageid = NULL;
        IF @dealStatusOccured = ''
            SET @dealStatusOccured = NULL;
        IF @startDate IS NULL
            SET @startDate = '01/01/1800';
        IF @endDate IS NULL
            SET @endDate = '01/01/2100';
        IF @dealSizeFrom IS NULL
            SET @dealSizeFrom = 0;
        IF @dealSizeTo IS NULL
            SET @dealSizeTo = 99999999999999;
        IF @freeText = ''
            BEGIN
                SELECT TOP (@page) *
                FROM
                (
                    SELECT ROW_NUMBER() OVER(
                           ORDER BY d.ReceivedDate DESC) AS RowNum, 
                           d.DealID, 
                           d.DealName, 
                           d.ReceivedDate, 
                           d.DealTypeID, 
                           d.DealSize, 
                           d.DealCurrencyCode, 
                           d.Notes, 
                           d.CreatedDateTime, 
                           d.ModifiedDateTime, 
                           c.companyName, 
                           c.CompanyContactID, 
                           ba.BusinessAreaTitle, 
                           ds.ProjectStatusTitle, 
                           dsa.DealStageTitle, 
                           p.CanView, 
                           d.dealStageid, 
                           0 PortfolioTargetTypeID, 
                           dbo.[F_GetSponserFund](d.DealID) SponserFunds, 
                           dbo.[F_GetDealFund](d.DealID) LinkedFunds
                    FROM tbl_deals d
                         LEFT JOIN tbl_companycontact c ON d.DealCurrentTargetID = c.CompanyContactID
                         LEFT JOIN tbl_BusinessArea ba ON c.CompanyBusinessAreaID = ba.BusinessAreaID
                         LEFT JOIN tbl_ModuleObjectPermissions AS P ON d.dealid = P.ModuleObjectID
                                                                       AND P.ModuleID = 6
                                                                       AND P.RoleID = @RoleID
                         LEFT JOIN tbl_DealStatus ds ON ds.ProjectStatusID = d.DealStatusID
                         LEFT JOIN tbl_DealStages dsa ON dsa.DealStageID = d.DealStageID
                    WHERE d.dealname LIKE @Character
                          AND 1 = CASE
                                      WHEN ReceivedDate BETWEEN @startDate AND @endDate
                                      THEN 1
									  WHEN  ReceivedDate IS NULL then 1
                                      ELSE 0
                                  END
                          AND ISNULL(DealSize, 0) BETWEEN ISNULL(@dealSizeFrom, DealSize) AND ISNULL(@dealSizeTo, DealSize)
                          AND 1 = CASE
                                      WHEN @senderIndividual IS NULL
                                      THEN 1
                                      WHEN d.DealSourceIndividualID <> 0
                                           AND d.DealSourceIndividualID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@senderIndividual, ',')
                    )
                                      THEN 1
                                      ELSE 0
                                  END
                         AND 1 = CASE
                                     WHEN @dealSectorid IS NULL
                                     THEN 1
                                     WHEN c.CompanyBusinessAreaID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@dealSectorid, ',')
                    )
                                     THEN 1
                                 END
                AND 1 = CASE
                            WHEN @senderCompany IS NULL
                            THEN 1
                            WHEN d.DealSourceCompanyID <> 0
                                 AND d.DealSourceCompanyID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@senderCompany, ',')
                    )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @dealTypeid IS NULL
                            THEN 1
                            WHEN d.DealTypeID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@dealTypeid, ',')
                    )
                            THEN 1
                        END
            AND 1 = CASE
                        WHEN @dealstatusid IS NULL
                        THEN 1
                        WHEN d.dealstatusid IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@dealstatusid, ',')
                    )
                        THEN 1
                    END
        AND 1 = CASE
                    WHEN @dealstageid IS NULL
                    THEN 1
                    WHEN d.DealStageID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@dealstageid, ',')
                    )
                    THEN 1
                END
        AND 1 = dbo.F_DealSearchOperator(d.DealID, @dealStatusCriteria, @dealStatusOccured)
        AND 1 = CASE
                    WHEN @MCTeamMembers IS NULL
                    THEN 1
                    WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_DealTeam dt
                        WHERE dt.dealid = d.dealid
                              AND individualid IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@MCTeamMembers, ',')
                        )
                    )
                    THEN 1
                END
        AND 1 = CASE
                    WHEN @fundID IS NULL
                    THEN 1
                    WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_DealVehicle dt
                        WHERE dt.dealid = d.dealid
                              AND dt.vehicleid IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@fundID, ',')
                        )
                    )
                    THEN 1
                END
        AND d.active = 1
        AND ISNULL(P.CanView, 1) = 1
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
                              AND b.TypeID = d.DealTypeID
                    )
                ) t
                WHERE t.RowNum > (@index * @page)
                ORDER BY ReceivedDate DESC;
        END;
            ELSE
            BEGIN
                SET @freeText = '"''' + ISNULL(@freeText, '') + '''"';
                SELECT TOP (@page) *
                FROM
                (
                    SELECT ROW_NUMBER() OVER(
                           ORDER BY d.ReceivedDate DESC) AS RowNum, 
                           d.DealID, 
                           d.DealName, 
                           d.ReceivedDate, 
                           d.DealTypeID, 
                           d.DealSize, 
                           d.DealCurrencyCode, 
                           d.Notes, 
                           d.CreatedDateTime, 
                           d.ModifiedDateTime, 
                           c.companyName, 
                           c.CompanyContactID, 
                           ba.BusinessAreaTitle, 
                           ds.ProjectStatusTitle, 
                           dsa.DealStageTitle, 
                           p.CanView, 
                           d.dealStageid, 
                           0 PortfolioTargetTypeID, 
                           dbo.[F_GetSponserFund](d.DealID) SponserFunds, 
                           dbo.[F_GetDealFund](d.DealID) LinkedFunds
                    FROM tbl_deals d
                         LEFT JOIN tbl_companycontact c ON d.DealCurrentTargetID = c.CompanyContactID
                         LEFT JOIN tbl_BusinessArea ba ON c.CompanyBusinessAreaID = ba.BusinessAreaID
                         LEFT JOIN tbl_ModuleObjectPermissions AS P ON d.dealid = P.ModuleObjectID
                                                                       AND P.ModuleID = 6
                                                                       AND P.RoleID = @RoleID
                         LEFT JOIN tbl_DealStatus ds ON ds.ProjectStatusID = d.DealStatusID
                         LEFT JOIN tbl_DealStages dsa ON dsa.DealStageID = d.DealStageID
                    WHERE d.dealname LIKE @Character
                          AND 1 = CASE
                                      WHEN ReceivedDate BETWEEN @startDate AND @endDate
                                      THEN 1
									  WHEN  ReceivedDate IS NULL then 1
                                      ELSE 0
                                  END
                          AND ISNULL(DealSize, 0) BETWEEN ISNULL(@dealSizeFrom, DealSize) AND ISNULL(@dealSizeTo, DealSize)
                          AND 1 = CASE
                                      WHEN @senderIndividual IS NULL
                                      THEN 1
                                      WHEN d.DealSourceIndividualID <> 0
                                           AND d.DealSourceIndividualID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@senderIndividual, ',')
                    )
                                      THEN 1
                                      ELSE 0
                                  END
                         AND 1 = CASE
                                     WHEN @dealSectorid IS NULL
                                     THEN 1
                                     WHEN c.CompanyBusinessAreaID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@dealSectorid, ',')
                    )
                                     THEN 1
                                 END
                AND 1 = CASE
                            WHEN @senderCompany IS NULL
                            THEN 1
                            WHEN d.DealSourceCompanyID <> 0
                                 AND d.DealSourceCompanyID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@senderCompany, ',')
                    )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @dealTypeid IS NULL
                            THEN 1
                            WHEN d.DealTypeID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@dealTypeid, ',')
                    )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @dealstatusid IS NULL
                            THEN 1
                            WHEN d.dealstatusid IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@dealstatusid, ',')
                    )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @dealstageid IS NULL
                            THEN 1
                            WHEN d.dealstageid IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@dealstageid, ',')
                    )
                            THEN 1
                        END
            AND 1 = dbo.F_DealSearchOperator(d.DealID, @dealStatusCriteria, @dealStatusOccured)
                AND 1 = CASE
                            WHEN @MCTeamMembers IS NULL
                            THEN 1
                            WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_DealTeam dt
                        WHERE dt.dealid = d.dealid
                              AND individualid IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@MCTeamMembers, ',')
                        )
                    )
                            THEN 1
                        END
        AND 1 = CASE
                    WHEN @fundID IS NULL
                    THEN 1
                    WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_DealVehicle dt
                        WHERE dt.dealid = d.dealid
                              AND dt.vehicleid IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@fundID, ',')
                        )
                    )
                    THEN 1
                END
        AND d.active = 1
        AND ISNULL(P.CanView, 1) = 1
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
                              AND b.TypeID = d.DealTypeID
                    )
                ) t
                WHERE t.RowNum > (@index * @page)
                ORDER BY ReceivedDate DESC;
        END;
    END;
