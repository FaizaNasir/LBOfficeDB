CREATE PROCEDURE [dbo].[proc_CompanySearch_GET] @RoleID                 VARCHAR(MAX), 
                                               @Gernal                 VARCHAR(1000) = NULL, 
                                               @CompanyTypeIDs         VARCHAR(1000) = NULL, 
                                               @ExternalAdvisorTypeIDs VARCHAR(1000) = NULL, 
                                               @CompanyCountryID       VARCHAR(1000) = NULL, 
                                               @CompanyIndustryID      VARCHAR(1000) = NULL, 
                                               @CompanyCityID          VARCHAR(1000) = NULL, 
                                               @CompanySectorID        VARCHAR(1000) = NULL, 
                                               @CompanyInvestorTypeID  VARCHAR(1000) = NULL, 
                                               @Character              VARCHAR(10)   = NULL, 
                                               @fundType               VARCHAR(1000) = NULL, 
                                               @index                  INT, 
                                               @page                   INT
AS
     IF @CompanyCountryID = '0'
         SET @CompanyCountryID = NULL;
     IF @CompanyTypeIDs = ''
         SET @CompanyTypeIDs = NULL;
     IF @Character IS NULL
         SET @Character = '%';
         ELSE
         SET @Character = @Character + '%';
    BEGIN
        IF @Gernal IS NULL
            BEGIN
                SELECT TOP (@page) t1.*, 
                                   CountryName
                FROM
                (
                    SELECT ROW_NUMBER() OVER(
                           ORDER BY CompanyName) AS RowNum, 
                           *
                    FROM
                    (
                        SELECT DISTINCT 
                               c.CompanyContactID, 
                               c.CompanyLogo, 
                               c.ExternalAdvisorTypeID, 
                               c.CompanyStatus, 
                               c.CompanyIndustryID, 
                               c.CompanyBusinessAreaID, 
                               c.CompanyBusinessDesc, 
                               c.CompanyName, 
                               c.CompanyWebSite, 
                               c.CompanyCreationDate, 
                               c.CompanyCreatedDate, 
                               c.CompanyStartCollaborationDate, 
                               c.CompanyActivity, 
                               c.CompanyLinkedIn, 
                               c.CompanyFacebook, 
                               c.CompanyTwitter, 
                               c.CompanyComments, 
                               office.CityID CompanyCityID, 
                               office.CountryID CompanyCountryID, 
                               office.StateID StateId, 
                               office.OfficeAddress CompanyAddress, 
                               office.OfficeZip CompanyZip, 
                               office.OfficePOBox CompanyPOBox, 
                               office.OfficePhone CompanyPhone, 
                               office.OfficeFax CompanyFax, 
                               office.OfficeID, 
                               office.OfficeCity, 
                        (
                            SELECT StateTitle
                            FROM tbl_state s
                            WHERE s.stateid = office.StateId
                        ) StateTitle, 
                               REPLACE(dbo.F_GetCompanyTypeNames(C.CompanyContactID), ',', ',') AS CompanyType, 
                               b.IndividualFullName CompanyMainContact, 
                               b.IndividualID CompanyMainIndividualID, 
                               b.ContactPositionInCompany CompanyMainContactPosition, 
                               b.ContactEmailAddressInCompany CompanyMainContactBusinessEmail, 
                        --(
                        --    SELECT CountryPhoneCode
                        --    FROM tbl_Country
                        --    WHERE CountryID = office.CountryID
                        --) AS CountryCode, 
                               canEdit
                        FROM tbl_CompanyContact C
                             OUTER APPLY
                        (
                            SELECT TOP (1) *
                            FROM tbl_CompanyOffice b
                            WHERE b.CompanyContactID = c.CompanyContactID
                                  AND b.Ismain = 1
                        ) AS office
                             LEFT JOIN tbl_CompanyContactType CT ON C.CompanyContactID = CT.CompanyContactID
                             LEFT JOIN tbl_CompanyContactExternalAdvisors EA ON EA.CompanyID = C.CompanyContactID
                             LEFT JOIN tbl_ModuleObjectPermissions AS P ON C.CompanyContactID = P.ModuleObjectID
                                                                           AND P.ModuleID = 5
                                                                           AND P.RoleID = @RoleID
                             LEFT JOIN tbl_InvestorTypeDetail ITD ON C.CompanyContactID = ITD.ObjectTypeID
                             OUTER APPLY
                        (
                            SELECT TOP 1 indiv.IndividualFullName, 
                                         indiv.IndividualID, 
                                         ci.ContactPositionInCompany, 
                                         ci.ContactEmailAddressInCompany
                            FROM tbl_CompanyIndividuals ci
                                 JOIN tbl_ContactIndividual indiv ON indiv.IndividualID = ci.ContactIndividualID
                            WHERE ci.CompanyContactID = c.CompanyContactID
                                  AND ci.isMainIndividual = 1
                        ) AS b
                        WHERE NOT EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_ContactTypePermission ctp
                            WHERE ctp.RoleID = @RoleID
                                  AND ctp.ModuleID = 5
                                  AND ctp.ContactTypesID = Ct.ContactTypeID
                                  AND ISNULL(ctp.CanView, 1) = 0
                        )
                              AND ISNULL(P.CanView, 1) = 1
                              AND c.companyname LIKE @Character
                              AND 1 = CASE
                                          WHEN @CompanyTypeIDs IS NULL
                                          THEN 1
                                          WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyContactType CT
                            WHERE C.CompanyContactID = CT.CompanyContactID
                                  AND ContactTypeID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanyTypeIDs, ',')
                            )
                        )
                                          THEN 1
                                      END
                             AND 1 = CASE
                                         WHEN @ExternalAdvisorTypeIDs IS NULL
                                         THEN 1
                                         WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyContactExternalAdvisors EA
                            WHERE EA.CompanyID = C.CompanyContactID
                                  AND ExternalAdvisorTypeID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@ExternalAdvisorTypeIDs, ',')
                            )
                        )
                                         THEN 1
                                     END
                        AND 1 = CASE
                                    WHEN @CompanyCountryID IS NULL
                                    THEN 1
                                    WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyOffice co
                            WHERE co.CompanyContactID = C.CompanyContactID
                                  AND co.CountryID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanyCountryID, ',')
                            )
                        )
                                    THEN 1
                                END
                    AND 1 = CASE
                                WHEN @CompanyIndustryID IS NULL
                                THEN 1
                                WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyIndustries
                            WHERE tbl_CompanyIndustries.CompanyIndustryID = C.CompanyIndustryID
                                  AND CompanyIndustryID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanyIndustryID, ',')
                            )
                        )
                                THEN 1
                            END
                    AND 1 = CASE
                                WHEN @CompanyCityID IS NULL
                                THEN 1
                                WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyOffice co
                            WHERE co.CompanyContactID = C.CompanyContactID
                                  AND co.CityID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanyCityID, ',')
                            )
                        )
                                THEN 1
                            END
                AND 1 = CASE
                            WHEN @CompanySectorID IS NULL
                            THEN 1
                            WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_BusinessArea
                            WHERE tbl_BusinessArea.BusinessAreaID = C.CompanyBusinessAreaID
                                  AND BusinessAreaID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanySectorID, ',')
                            )
                        )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @fundType IS NULL
                            THEN 1
                            WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyContact_FundType ft
                            WHERE ft.CompanyID = C.CompanyContactID
                                  AND FundTypeId IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@fundType, ',')
                            )
                        )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @CompanyInvestorTypeID IS NULL
                            THEN 1
                            WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_InvestorType
                            WHERE tbl_InvestorType.InvestorTypeID = ITD.InvestorTypeID
                                  AND InvestorTypeID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanyInvestorTypeID, ',')
                            )
                            AND IsCompany = 1
                        )
                            THEN 1
                        END
            AND c.active = 1
                    ) t
                    LEFT JOIN tbl_Country coun ON coun.CountryID = t.CompanyCountryID
                    WHERE NOT EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_BlockedPermission b
                        WHERE b.moduleName = 'Company'
                              AND UserRole = @RoleID
                              AND b.ObjectID = CompanyContactID
                    )
                          AND CompanyContactID NOT IN
                    (
                        SELECT cct.CompanyContactID
                        FROM tbl_BlockedGroupPermission b
                             JOIN tbl_CompanyContactType cct ON b.TypeID = cct.ContactTypeID
                        WHERE b.moduleID = 5
                              AND UserRole = @RoleID
                              AND 1 = CASE
                                          WHEN @CompanyTypeIDs IS NULL
                                          THEN 1
                                          WHEN ContactTypeID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@CompanyTypeIDs, ',')
                        )
                                          THEN 1
                                      END
                    )
                ) t1
                WHERE t1.RowNum > (@index * @page)
                ORDER BY CompanyName;
        END;
            ELSE
            BEGIN
                SET @Gernal = '%' + @Gernal + '%';
                SELECT TOP (@page) t1.*, 
                                   CountryName
                FROM
                (
                    SELECT ROW_NUMBER() OVER(
                           ORDER BY CompanyName) AS RowNum, 
                           *
                    FROM
                    (
                        SELECT DISTINCT 
                               c.CompanyContactID, 
                               c.CompanyLogo, 
                               c.ExternalAdvisorTypeID, 
                               c.CompanyStatus, 
                               c.CompanyIndustryID, 
                               c.CompanyBusinessAreaID, 
                               c.CompanyBusinessDesc, 
                               c.CompanyName, 
                               c.CompanyWebSite, 
                               c.CompanyCreationDate, 
                               c.CompanyCreatedDate, 
                               c.CompanyStartCollaborationDate, 
                               c.CompanyActivity, 
                               c.CompanyLinkedIn, 
                               c.CompanyFacebook, 
                               c.CompanyTwitter, 
                               c.CompanyComments, 
                               office.CityID CompanyCityID, 
                               office.CountryID CompanyCountryID, 
                               office.StateID StateId, 
                               office.OfficeAddress CompanyAddress, 
                               office.OfficeZip CompanyZip, 
                               office.OfficePOBox CompanyPOBox, 
                               office.OfficePhone CompanyPhone, 
                               office.OfficeFax CompanyFax, 
                               office.OfficeID, 
                               office.OfficeCity, 
                        (
                            SELECT StateTitle
                            FROM tbl_state s
                            WHERE s.stateid = office.StateId
                        ) StateTitle, 
                               REPLACE(dbo.F_GetCompanyTypeNames(C.CompanyContactID), ',', ',') AS CompanyType, 
                               b.IndividualFullName CompanyMainContact, 
                               b.IndividualID CompanyMainIndividualID, 
                               b.ContactPositionInCompany CompanyMainContactPosition, 
                               b.ContactEmailAddressInCompany CompanyMainContactBusinessEmail, 
                        --(
                        --    SELECT CountryPhoneCode
                        --    FROM tbl_Country
                        --    WHERE CountryID = office.CountryID
                        --) AS CountryCode, 
                               canEdit
                        FROM tbl_CompanyContact C
                             OUTER APPLY
                        (
                            SELECT TOP (1) *
                            FROM tbl_CompanyOffice b
                            WHERE b.CompanyContactID = c.CompanyContactID
                                  AND b.Ismain = 1
                        ) AS office
                             LEFT JOIN tbl_CompanyContactType CT ON C.CompanyContactID = CT.CompanyContactID
                             LEFT JOIN tbl_CompanyContactExternalAdvisors EA ON EA.CompanyID = C.CompanyContactID
                             LEFT JOIN tbl_ModuleObjectPermissions AS P ON C.CompanyContactID = P.ModuleObjectID
                                                                           AND P.ModuleID = 5
                                                                           AND P.RoleID = @RoleID
                             LEFT JOIN tbl_InvestorTypeDetail ITD ON C.CompanyContactID = ITD.ObjectTypeID
                             OUTER APPLY
                        (
                            SELECT TOP 1 indiv.IndividualFullName, 
                                         indiv.IndividualID, 
                                         ci.ContactPositionInCompany, 
                                         ci.ContactEmailAddressInCompany
                            FROM tbl_CompanyIndividuals ci
                                 JOIN tbl_ContactIndividual indiv ON indiv.IndividualID = ci.ContactIndividualID
                            WHERE ci.CompanyContactID = c.CompanyContactID
                                  AND ci.isMainIndividual = 1
                        ) AS b
                        WHERE NOT EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_ContactTypePermission ctp
                            WHERE ctp.RoleID = @RoleID
                                  AND ctp.ModuleID = 5
                                  AND ctp.ContactTypesID = Ct.ContactTypeID
                                  AND ISNULL(ctp.CanView, 1) = 0
                        )
                              AND ISNULL(P.CanView, 1) = 1
                              AND c.companyname LIKE @Character
                              AND (c.companyname LIKE @Gernal
                                   OR c.CompanyBusinessDesc LIKE @Gernal
                                   OR c.CompanyComments LIKE @Gernal)
                              AND 1 = CASE
                                          WHEN @CompanyTypeIDs IS NULL
                                          THEN 1
                                          WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyContactType CT
                            WHERE C.CompanyContactID = CT.CompanyContactID
                                  AND ContactTypeID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanyTypeIDs, ',')
                            )
                        )
                                          THEN 1
                                      END
                             AND 1 = CASE
                                         WHEN @ExternalAdvisorTypeIDs IS NULL
                                         THEN 1
                                         WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyContactExternalAdvisors EA
                            WHERE EA.CompanyID = C.CompanyContactID
                                  AND ExternalAdvisorTypeID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@ExternalAdvisorTypeIDs, ',')
                            )
                        )
                                         THEN 1
                                     END
                        AND 1 = CASE
                                    WHEN @CompanyCountryID IS NULL
                                    THEN 1
                                    WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyOffice co
                            WHERE co.CompanyContactID = C.CompanyContactID
                                  AND co.CountryID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanyCountryID, ',')
                            )
                        )
                                    THEN 1
                                END
                    AND 1 = CASE
                                WHEN @CompanyIndustryID IS NULL
                                THEN 1
                                WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyIndustries
                            WHERE tbl_CompanyIndustries.CompanyIndustryID = C.CompanyIndustryID
                                  AND CompanyIndustryID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanyIndustryID, ',')
                            )
                        )
                                THEN 1
                            END
                    AND 1 = CASE
                                WHEN @CompanyCityID IS NULL
                                THEN 1
                                WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyOffice co
                            WHERE co.CompanyContactID = C.CompanyContactID
                                  AND co.CityID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanyCityID, ',')
                            )
                        )
                                THEN 1
                            END
                AND 1 = CASE
                            WHEN @CompanySectorID IS NULL
                            THEN 1
                            WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_BusinessArea
                            WHERE tbl_BusinessArea.BusinessAreaID = C.CompanyBusinessAreaID
                                  AND BusinessAreaID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanySectorID, ',')
                            )
                        )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @fundType IS NULL
                            THEN 1
                            WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_CompanyContact_FundType ft
                            WHERE ft.CompanyID = C.CompanyContactID
                                  AND FundTypeId IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@fundType, ',')
                            )
                        )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @CompanyInvestorTypeID IS NULL
                            THEN 1
                            WHEN EXISTS
                        (
                            SELECT TOP 1 1
                            FROM tbl_InvestorType
                            WHERE tbl_InvestorType.InvestorTypeID = ITD.InvestorTypeID
                                  AND InvestorTypeID IN
                            (
                                SELECT *
                                FROM dbo.[SplitCSV](@CompanyInvestorTypeID, ',')
                            )
                            AND IsCompany = 1
                        )
                            THEN 1
                        END
                AND c.active = 1
                    ) t
                    LEFT JOIN tbl_Country coun ON coun.CountryID = t.CompanyCountryID
                    WHERE NOT EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_BlockedPermission b
                        WHERE b.moduleName = 'Company'
                              AND UserRole = @RoleID
                              AND b.ObjectID = CompanyContactID
                    )
                          AND CompanyContactID NOT IN
                    (
                        SELECT cct.CompanyContactID
                        FROM tbl_BlockedGroupPermission b
                             JOIN tbl_CompanyContactType cct ON b.TypeID = cct.ContactTypeID
                        WHERE b.moduleID = 5
                              AND UserRole = @RoleID
                              AND 1 = CASE
                                          WHEN @CompanyTypeIDs IS NULL
                                          THEN 1
                                          WHEN ContactTypeID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@CompanyTypeIDs, ',')
                        )
                                          THEN 1
                                      END
                    )
                ) t1
                WHERE t1.RowNum > (@index * @page)
                ORDER BY CompanyName;
        END;
    END;
