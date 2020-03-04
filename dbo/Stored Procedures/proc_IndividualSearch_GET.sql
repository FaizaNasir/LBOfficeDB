CREATE PROCEDURE [dbo].[proc_IndividualSearch_GET] @RoleID               VARCHAR(100), 
                                                   @Gernal               VARCHAR(1000) = NULL, 
                                                   @CompanyTypeIDs       VARCHAR(1000) = NULL, 
                                                   @IndividualTypeIds    VARCHAR(1000) = NULL, 
                                                   @RMIds                VARCHAR(1000) = NULL, 
                                                   @IndividualPosition   VARCHAR(1000) = NULL, 
                                                   @IndividualDepartment VARCHAR(1000) = NULL, 
                                                   @IndividualCountryID  VARCHAR(1000) = NULL, 
                                                   @IndividualCityID     VARCHAR(1000) = NULL, 
                                                   @Character            VARCHAR(10)   = NULL, 
                                                   @IndividualCompanyIDs VARCHAR(1000) = NULL, 
                                                   @IndividualExpertIn   VARCHAR(1000) = NULL, 
                                                   @index                INT, 
                                                   @page                 INT
AS
     IF @Character IS NULL
         SET @Character = '%';
         ELSE
         SET @Character = @Character + '%';
     IF @IndividualCountryID = '0'
         SET @IndividualCountryID = NULL;
     PRINT @Character;
    BEGIN
        IF @Gernal IS NULL
            BEGIN
                SELECT TOP (@page) *
                FROM
                (
                    SELECT DISTINCT 
                           ROW_NUMBER() OVER(
                           ORDER BY c.IndividualLastName) AS RowNum, 
                           c.*, 
                           ci.CompanyContactID, 
                           ci.CompanyIndividualID, 
                           ci.ContactIndividualID, 
                           ci.TeamTypeName, 
                           ci.isMainCompany, 
                           ci.ContactPositionInCompany, 
                           ci.ContactDepartmentInCompany, 
                           ci.ContactDateOfJoiningInCompany, 
                           ci.ContactDateOfLeavingFromCompany, 
                           ci.ContactDirectLineInCompany, 
                           ci.ContactDirectFaxInCompany, 
                           ci.ContactFaxNumberInCompany, 
                           ci.ContactMobileNumberInCompany, 
                           ci.ContactEmailAddressInCompany, 
                           ci.ContactPrivateAssitantID, 
                           ci.CompanyName, 
                           ci.CompanyStatus, 
                           ci.CompanyMainIndividualID, 
                           ci.CompanyCityID, 
                           ci.CompanyCountryID, 
                           ci.ExternalAdvisorTypeID, 
                           ci.CompanyLogo, 
                           ci.CompanyIndustryID, 
                           ci.CompanyBusinessAreaID, 
                           ci.CompanyBusinessDesc, 
                           ci.CompanyWebSite, 
                           ci.CompanyAddress, 
                           ci.CompanyZip, 
                           ci.CompanyPOBox, 
                           ci.CompanyPhone, 
                           ci.CompanyFax, 
                           ci.CompanyCreationDate, 
                           ci.CompanyCreatedDate, 
                           ci.CompanyStartCollaborationDate, 
                           ci.CompanyActivity, 
                           ci.CompanyFacebook, 
                           ci.CompanyTwitter, 
                           ci.CompanyLinkedIn, 
                           ci.Expr1, 
                           PA.IndividualFirstName AS PAFirstName, 
                           PA.IndividualLastName AS PALastName, 
                           PA.IndividualEmail AS PAEmail, 
                           PA.IndividualMobile AS PAMObile, 
                           pa.IndividualFax AS PAfax, 
                           P.*, 
                           CI.CompanyName AS MainCompanyName, 
                           dbo.F_GetCompanyTypeNames(CI.CompanyContactID) AS CompanyType, 
                    (
                        SELECT TOP 1 CR.[IndividualFullName]
                        FROM [tbl_ContactIndividualRM] RM
                             JOIN [tbl_ContactIndividual] CR ON RM.[ManagementCompanyIndividualID] = CR.[IndividualID]
                        WHERE RM.[IndividualId] = C.IndividualId
                              AND RM.isMain = 1
                    ) AS RM, 
                    (
                        SELECT CountryPhoneCode
                        FROM tbl_Country country
                        WHERE co.CountryID = country.CountryID
                    ) AS CountryCode
                    FROM tbl_ContactIndividual C
                         LEFT JOIN tbl_companyindividuals cin ON cin.ContactIndividualID = C.IndividualID
                                                                 AND cin.ismaincompany = 1
                         LEFT JOIN tbl_companyoffice co ON cin.OfficeID = co.officeid
                         LEFT JOIN vw_ContactIndividualsWithCompanyContacts CI ON CI.ContactIndividualID = C.IndividualID
                                                                                  AND CI.isMainCompany = 1
                                                                                  AND CI.TeamTypeName = 'Executive Team'
                         LEFT JOIN tbl_CoNTACTIndividual PA ON PA.IndividualID = CI.ContactPrivateAssitantID
                         LEFT JOIN tbl_ModuleObjectPermissions AS P ON C.IndividualID = P.ModuleObjectID
                                                                       AND P.ModuleName = 'ContactIndividual'
                                                                       AND P.RoleID = @RoleID
                         LEFT JOIN tbl_companycontact cc ON cc.CompanyContactID = ci.CompanyContactID
                    WHERE NOT EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_ContactIndividualContactTypes(NOLOCK) ict
                             JOIN tbl_ContactTypePermission ctp ON ctp.ContactTypesID = ict.ContactIndividualTypeID
                        WHERE ict.ContactIndividualID = C.IndividualID
                              AND ctp.RoleID = @RoleID
                              AND ctp.ModuleID = 4
                              AND ict.Active = 1
                              AND ISNULL(ctp.CanView, 1) = 0
                    )
                        AND ISNULL(P.CanView, 1) = 1
                        AND C.IndividualLastName LIKE @Character
                        AND 1 = CASE
                                    WHEN @CompanyTypeIDs IS NULL
                                    THEN 1
                                    WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyContactType CT
                             JOIN tbl_CompanyIndividuals cci ON CT.CompanyContactID = cci.CompanyContactID
                                                                AND cci.TeamTypeName = 'Executive Team'
                                                                AND cci.isMainCompany = 1
                        WHERE CT.ContactTypeID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@CompanyTypeIDs, ',')
                        )
                             AND CT.CompanyContactID = CI.CompanyContactID
                    )
                                    THEN 1
                                END
                          AND 1 = CASE
                                      WHEN @RMIds IS NULL
                                      THEN 1
                                      WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_ContactIndividualRM RM
                        WHERE RM.IndividualId = C.IndividualId
                              AND RM.ManagementCompanyIndividualID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@RMIds, ',')
                        )
                    )
                                      THEN 1
                                  END
                         AND 1 = CASE
                                     WHEN @IndividualTypeIds IS NULL
                                     THEN 1
                                     WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_ContactIndividualContactTypes CICT
                        WHERE CICT.ContactIndividualID = C.IndividualID
                              AND ContactIndividualTypeID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualTypeIds, ',')
                        )
                    )
                                     THEN 1
                                 END
                    AND 1 = CASE
                                WHEN @IndividualPosition IS NULL
                                THEN 1
                                WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyIndividuals CIWCC
                        WHERE CIWCC.ContactIndividualID = C.IndividualID
                              AND CIWCC.ContactDateOfLeavingFromCompany IS NULL
                              AND CIWCC.ContactPositionInCompany IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualPosition, ',')
                        )
                    )
                                THEN 1
                            END
                AND 1 = CASE
                            WHEN @IndividualExpertIn IS NULL
                            THEN 1
                            WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_ContactIndividual
                        WHERE tbl_ContactIndividual.IndividualExpertIn = C.IndividualExpertIn
                              AND tbl_ContactIndividual.IndividualExpertIn IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualExpertIn, ',')
                        )
                    )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @IndividualDepartment IS NULL
                            THEN 1
                            WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyIndividuals CIWCC
                        WHERE CIWCC.ContactIndividualID = C.IndividualID
                              AND CIWCC.ContactDepartmentInCompany IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualDepartment, ',')
                        )
                    )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @IndividualCountryID IS NULL
                            THEN 1
                            WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_Country
                        WHERE tbl_Country.CountryID = C.IndividualCountryID
                              AND CountryID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualCountryID, ',')
                        )
                    )
                    OR EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyIndividuals ci
                             JOIN tbl_companyoffice co ON ci.officeid = co.OfficeID
                        WHERE ci.ContactIndividualID = c.IndividualID
                              AND ci.isMainCompany = 1
                              AND ci.ContactDateOfLeavingFromCompany IS NULL
                              AND co.CountryID IN
                        (
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualCountryID, ',')
                        )
                        )
                    )
                            THEN 1
                        END
        AND 1 = CASE
                    WHEN @IndividualCityID IS NULL
                    THEN 1
                    WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_City
                        WHERE tbl_City.CityID = C.IndividualCityID
                              AND CityID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualCityID, ',')
                        )
                    )
            OR EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyIndividuals CCCI
                             JOIN tbl_companyoffice co ON co.officeID = CCCi.OfficeID
                        WHERE CCCI.ContactIndividualID = C.IndividualID
                              AND CCCI.ContactDateOfLeavingFromCompany IS NULL
                              AND co.CityID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualCityID, ',')
                        )
                    )
                    THEN 1
                END
    AND 1 = CASE
                WHEN @IndividualCompanyIDs IS NULL
                THEN 1
                WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyIndividuals CCCI
                        WHERE CCCI.ContactIndividualID = C.IndividualID
                              AND CCCI.CompanyContactID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualCompanyIDs, ',')
                        )
                    )
                THEN 1
            END
     AND c.active = 1
     AND C.IndividualID NOT IN
                    (
                        SELECT b.ObjectID
                        FROM tbl_BlockedPermission b
                        WHERE b.moduleName = 'Contacts'
                              AND UserRole = @RoleID
                    )
     AND C.IndividualID NOT IN
                    (
                        SELECT cct.ContactIndividualID
                        FROM tbl_BlockedGroupPermission b
                             JOIN tbl_ContactIndividualContactTypes cct ON b.TypeID = cct.ContactIndividualTypeID
                        WHERE b.moduleID = 4
                              AND UserRole = @RoleID
                    )
                ) t
                WHERE t.RowNum > (@index * @page)
                ORDER BY IndividualLastname;
        END;
            ELSE
            BEGIN
                SET @Gernal = '%' + @Gernal + '%';
                SELECT TOP (@page) *
                FROM
                (
                    SELECT DISTINCT 
                           ROW_NUMBER() OVER(
                           ORDER BY c.IndividualLastName) AS RowNum, 
                           c.*, 
                           ci.CompanyContactID, 
                           ci.CompanyIndividualID, 
                           ci.ContactIndividualID, 
                           ci.TeamTypeName, 
                           ci.isMainCompany, 
                           ci.ContactPositionInCompany, 
                           ci.ContactDepartmentInCompany, 
                           ci.ContactDateOfJoiningInCompany, 
                           ci.ContactDateOfLeavingFromCompany, 
                           ci.ContactDirectLineInCompany, 
                           ci.ContactDirectFaxInCompany, 
                           ci.ContactFaxNumberInCompany, 
                           ci.ContactMobileNumberInCompany, 
                           ci.ContactEmailAddressInCompany, 
                           ci.ContactPrivateAssitantID, 
                           ci.CompanyName, 
                           ci.CompanyStatus, 
                           ci.CompanyMainIndividualID, 
                           ci.CompanyCityID, 
                           ci.CompanyCountryID, 
                           ci.ExternalAdvisorTypeID, 
                           ci.CompanyLogo, 
                           ci.CompanyIndustryID, 
                           ci.CompanyBusinessAreaID, 
                           ci.CompanyBusinessDesc, 
                           ci.CompanyWebSite, 
                           ci.CompanyAddress, 
                           ci.CompanyZip, 
                           ci.CompanyPOBox, 
                           ci.CompanyPhone, 
                           ci.CompanyFax, 
                           ci.CompanyCreationDate, 
                           ci.CompanyCreatedDate, 
                           ci.CompanyStartCollaborationDate, 
                           ci.CompanyActivity, 
                           ci.CompanyFacebook, 
                           ci.CompanyTwitter, 
                           ci.CompanyLinkedIn, 
                           ci.Expr1, 
                           PA.IndividualFirstName AS PAFirstName, 
                           PA.IndividualLastName AS PALastName, 
                           PA.IndividualEmail AS PAEmail, 
                           PA.IndividualMobile AS PAMObile, 
                           pa.IndividualFax AS PAfax, 
                           P.*, 
                           CI.CompanyName AS MainCompanyName, 
                           dbo.F_GetCompanyTypeNames(CI.CompanyContactID) AS CompanyType, 
                    (
                        SELECT TOP 1 CR.[IndividualFullName]
                        FROM [tbl_ContactIndividualRM] RM
                             JOIN [tbl_ContactIndividual] CR ON RM.[ManagementCompanyIndividualID] = CR.[IndividualID]
                        WHERE RM.[IndividualId] = C.IndividualId
                              AND RM.isMain = 1
                    ) AS RM, 
                    (
                        SELECT CountryPhoneCode
                        FROM tbl_companyindividuals cin
                             JOIN tbl_companyoffice co ON cin.OfficeID = co.officeid
                                                          AND cin.ContactIndividualID = 9203
                                                          AND cin.ismaincompany = 1
                             JOIN tbl_Country country ON co.CountryID = country.CountryID
                    ) AS CountryCode
                    FROM tbl_ContactIndividual C
                         LEFT JOIN tbl_companyindividuals cin ON cin.ContactIndividualID = C.IndividualID
                                                                 AND cin.ismaincompany = 1
                         LEFT JOIN tbl_companyoffice co ON cin.OfficeID = co.officeid
                         LEFT JOIN vw_ContactIndividualsWithCompanyContacts CI ON CI.ContactIndividualID = C.IndividualID
                                                                                  AND CI.isMainCompany = 1
                                                                                  AND CI.TeamTypeName = 'Executive Team'
                         LEFT JOIN tbl_CoNTACTIndividual PA ON PA.IndividualID = CI.ContactPrivateAssitantID
                         LEFT JOIN tbl_ModuleObjectPermissions AS P ON C.IndividualID = P.ModuleObjectID
                                                                       AND P.ModuleName = 'ContactIndividual'
                                                                       AND P.RoleID = @RoleID
                         LEFT JOIN tbl_companycontact cc ON cc.CompanyContactID = ci.CompanyContactID
                    WHERE NOT EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_ContactIndividualContactTypes(NOLOCK) ict
                             JOIN tbl_ContactTypePermission ctp ON ctp.ContactTypesID = ict.ContactIndividualTypeID
                        WHERE ict.ContactIndividualID = C.IndividualID
                              AND ctp.RoleID = @RoleID
                              AND ctp.ModuleID = 4
                              AND ict.Active = 1
                              AND ISNULL(ctp.CanView, 1) = 0
                    )
                        AND ISNULL(P.CanView, 1) = 1
                        AND C.IndividualLastName LIKE @Character
                        AND C.IndividualFullName LIKE @Gernal
                        AND 1 = CASE
                                    WHEN @CompanyTypeIDs IS NULL
                                    THEN 1
                                    WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyContactType CT
                             JOIN tbl_CompanyIndividuals cci ON CT.CompanyContactID = cci.CompanyContactID
                                                                AND cci.TeamTypeName = 'Executive Team'
                                                                AND cci.isMainCompany = 1
                        WHERE CT.ContactTypeID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@CompanyTypeIDs, ',')
                        )
                             AND CT.CompanyContactID = CI.CompanyContactID
                    )
                                    THEN 1
                                END
                          AND 1 = CASE
                                      WHEN @RMIds IS NULL
                                      THEN 1
                                      WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_ContactIndividualRM RM
                        WHERE RM.IndividualId = C.IndividualId
                              AND RM.ManagementCompanyIndividualID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@RMIds, ',')
                        )
                    )
                                      THEN 1
                                  END
                         AND 1 = CASE
                                     WHEN @IndividualTypeIds IS NULL
                                     THEN 1
                                     WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_ContactIndividualContactTypes CICT
                        WHERE CICT.ContactIndividualID = C.IndividualID
                              AND ContactIndividualTypeID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualTypeIds, ',')
                        )
                    )
                                     THEN 1
                                 END
                    AND 1 = CASE
                                WHEN @IndividualPosition IS NULL
                                THEN 1
                                WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyIndividuals CIWCC
                        WHERE CIWCC.ContactIndividualID = C.IndividualID
                              AND CIWCC.ContactDateOfLeavingFromCompany IS NULL
                              AND CIWCC.ContactPositionInCompany IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualPosition, ',')
                        )
                    )
                                THEN 1
                            END
                AND 1 = CASE
                            WHEN @IndividualExpertIn IS NULL
                            THEN 1
                            WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_ContactIndividual
                        WHERE tbl_ContactIndividual.IndividualExpertIn = C.IndividualExpertIn
                              AND tbl_ContactIndividual.IndividualExpertIn IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualExpertIn, ',')
                        )
                    )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @IndividualDepartment IS NULL
                            THEN 1
                            WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyIndividuals CIWCC
                        WHERE CIWCC.ContactIndividualID = C.IndividualID
                              AND CIWCC.ContactDepartmentInCompany IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualDepartment, ',')
                        )
                    )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @IndividualCountryID IS NULL
                            THEN 1
                            WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_Country
                        WHERE tbl_Country.CountryID = C.IndividualCountryID
                              AND CountryID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualCountryID, ',')
                        )
                    )
                    OR EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyIndividuals ci
                             JOIN tbl_companyoffice co ON ci.officeid = co.OfficeID
                        WHERE ci.ContactIndividualID = c.IndividualID
                              AND ci.isMainCompany = 1
                              AND ci.ContactDateOfLeavingFromCompany IS NULL
                              AND co.CountryID IN
                        (
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualCountryID, ',')
                        )
                        )
                    )
                            THEN 1
                        END
                AND 1 = CASE
                            WHEN @IndividualCityID IS NULL
                            THEN 1
                            WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_City
                        WHERE tbl_City.CityID = C.IndividualCityID
                              AND CityID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualCityID, ',')
                        )
                    )
                    OR EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyIndividuals CCCI
                             JOIN tbl_companyoffice co ON co.officeID = CCCi.OfficeID
                        WHERE CCCI.ContactIndividualID = C.IndividualID
                              AND CCCI.ContactDateOfLeavingFromCompany IS NULL
                              AND co.CityID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualCityID, ',')
                        )
                    )
                            THEN 1
                        END
            AND 1 = CASE
                        WHEN @IndividualCompanyIDs IS NULL
                        THEN 1
                        WHEN EXISTS
                    (
                        SELECT TOP 1 1
                        FROM tbl_CompanyIndividuals CCCI
                        WHERE CCCI.ContactIndividualID = C.IndividualID
                              AND CCCI.CompanyContactID IN
                        (
                            SELECT *
                            FROM dbo.[SplitCSV](@IndividualCompanyIDs, ',')
                        )
                    )
                        THEN 1
                    END
                AND c.active = 1
                AND C.IndividualID NOT IN
                    (
                        SELECT b.ObjectID
                        FROM tbl_BlockedPermission b
                        WHERE b.moduleName = 'Contacts'
                              AND UserRole = @RoleID
                    )
                AND C.IndividualID NOT IN
                    (
                        SELECT cct.ContactIndividualID
                        FROM tbl_BlockedGroupPermission b
                             JOIN tbl_ContactIndividualContactTypes cct ON b.TypeID = cct.ContactIndividualTypeID
                        WHERE b.moduleID = 4
                              AND UserRole = @RoleID
                    )
                ) t
                WHERE t.RowNum > (@index * @page)
                ORDER BY IndividualLastname;
        END;
    END;
