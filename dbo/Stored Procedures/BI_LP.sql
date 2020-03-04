CREATE PROC [dbo].[BI_LP]
AS
    BEGIN
        SELECT DISTINCT 
               FundName 'Fund name', 
               t.ObjectID 'ID', 
               LPName 'LP name',
               CASE
                   WHEN t.ModuleID = 4
                   THEN conind.IndividualTitle
               END 'Title',
               CASE
                   WHEN t.ModuleID = 4
                   THEN conind.IndividualFirstName
               END 'First name',
               CASE
                   WHEN t.ModuleID = 4
                   THEN conind.IndividualMiddleName
               END 'Middle name',
               CASE
                   WHEN t.ModuleID = 4
                   THEN conind.IndividualLastName
               END 'Last name',
               CASE
                   WHEN t.ModuleID = 4
                   THEN conind.IndividualDOB
               END 'Birthdate', 
               LPType 'LP type',
               CASE
                   WHEN t.ModuleID = 4
                   THEN conind.IndividualEmail
                   WHEN t.ModuleID = 5
                   THEN cc.IndividualEmail
               END 'Personal email',
               CASE
                   WHEN t.ModuleID = 4
                   THEN
        (
            SELECT TOP 1 ContactEmailAddressInCompany
            FROM tbl_companyindividuals be
            WHERE be.ContactIndividualID = conind.individualid
                  AND be.isMainCompany = 1
        )
                   WHEN t.ModuleID = 5
                   THEN
        (
            SELECT TOP 1 ContactEmailAddressInCompany
            FROM tbl_companyindividuals be
            WHERE be.ContactIndividualID = cc.individualid
                  AND be.isMainCompany = 1
        )
               END 'Business email',
               CASE
                   WHEN ci.isMainIndividual = 1
                   THEN 'Yes'
                   ELSE ''
               END 'Main contact', 
               ISNULL(cc.IndividualTitle, '') + ' ' + ISNULL(cc.IndividualLastName, '') + ' ' + ISNULL(cc.IndividualFirstName, '') + ' ' + ISNULL(cc.IndividualMiddleName, '') 'Team member',
               CASE
                   WHEN t.ModuleID = 4
                   THEN conind.IndividualAddress
                   WHEN t.moduleid = 5
                   THEN co.OfficeAddress
               END Address,
               CASE
                   WHEN t.ModuleID = 4
                   THEN
        (
            SELECT cityname
            FROM tbl_city c
            WHERE c.cityid = conind.IndividualCityID
        )
                   WHEN t.moduleid = 5
                   THEN co.OfficeCity
               END City,
               CASE
                   WHEN t.ModuleID = 4
                   THEN conind.IndividualZipCode
                   WHEN t.moduleid = 5
                   THEN co.OfficeZip
               END 'Zip code', 
        (
            SELECT StateTitle
            FROM tbl_state s
            WHERE stateid = CASE
                                WHEN t.ModuleID = 4
                                THEN conind.StateID
                                WHEN t.moduleid = 5
                                THEN co.StateID
                            END
        ) State, 
        (
            SELECT CountryName
            FROM tbl_Country c
            WHERE CountryID = CASE
                                  WHEN t.ModuleID = 4
                                  THEN conind.IndividualCountryID
                                  WHEN t.moduleid = 5
                                  THEN co.CountryID
                              END
        ) Country, 
        (
            SELECT ISO
            FROM tbl_Country c
            WHERE CountryID = CASE
                                  WHEN t.ModuleID = 4
                                  THEN conind.IndividualCountryID
                                  WHEN t.moduleid = 5
                                  THEN co.CountryID
                              END
        ) CountryISO, 
        (
            SELECT ISO2
            FROM tbl_Country c
            WHERE CountryID = CASE
                                  WHEN t.ModuleID = 4
                                  THEN conind.IndividualCountryID
                                  WHEN t.moduleid = 5
                                  THEN co.CountryID
                              END
        ) CountryISO2, 
        (
            SELECT CountryName
            FROM tbl_Country c
            WHERE CountryID = CASE
                                  WHEN t.ModuleID = 4
                                  THEN n.CountryID
                              END
        ) Nationality, 
        (
            SELECT ISO
            FROM tbl_Country c
            WHERE CountryID = CASE
                                  WHEN t.ModuleID = 4
                                  THEN n.CountryID
                              END
        ) NationalityISO, 
        (
            SELECT ISO2
            FROM tbl_Country c
            WHERE CountryID = CASE
                                  WHEN t.ModuleID = 4
                                  THEN n.CountryID
                              END
        ) NationalityISO2, 
               '----Values----' '----Values----', 
               Commitments, 
               CumulatedCalls 'Cumulated calls', 
               Distributions, 
               LastNAV 'Last NAV', 
               DateLastNAV 'Date last NAV', 
               per.IRRNet IRR, 
               per.MultipleNet Multiple, 
               '----Compliance----' '----Compliance----',
               CASE
                   WHEN AMLFinalized = 1
                   THEN 'Yes'
                   WHEN AMLFinalized = 0
                   THEN 'No'
                   ELSE ''
               END 'AML finalized',
               CASE
                   WHEN ClientType = 1
                   THEN 'Pro'
                   WHEN ClientType = 0
                   THEN 'Not pro'
                   ELSE ''
               END 'Client type',
               CASE
                   WHEN AMLCategory = 1
                   THEN 'Weak'
                   WHEN AMLCategory = 2
                   THEN 'Enhanced absolute'
                   WHEN AMLCategory = 3
                   THEN 'Enhanced relative'
                   ELSE ''
               END 'AML category',
               CASE
                   WHEN ClientPoliticallyExposed = 1
                   THEN 'Yes'
                   WHEN ClientPoliticallyExposed = 0
                   THEN 'No'
                   ELSE ''
               END 'Client politically exposed', 
        (
            SELECT countryname
            FROM tbl_country c
            WHERE c.CountryID = ResidenceCountry
        ) 'Residence country',
               CASE
                   WHEN ClientMet = 1
                   THEN 'Yes'
                   WHEN ClientMet = 0
                   THEN 'No'
                   ELSE ''
               END 'Client met', 
               LastReviewDate 'Last review date', 
               '----LP distribution team----' '----LP distribution team----', 
        (
            SELECT DocumentTypeName
            FROM tbl_DocumentType d
            WHERE d.DocumentTypeID = lpe.DocumentTypeID
        ) 'Document type', 
               dbo.[F_LPEmailConfigDetail](lpe.LPEmailConfigID, 0) 'To contacts', 
               lpe.ToEmailAddress 'To email address', 
               dbo.[F_LPEmailConfigDetail](lpe.LPEmailConfigID, 1) 'Cc contacts', 
               lpe.CCEmailAddress 'Cc email address'
        FROM
        (
            SELECT VehicleID, 
                   FundName, 
                   LPname, 
                   LPType, 
                   LimitedPartnerID, 
                   ModuleID, 
                   ObjectID, 
                   SUM(Commitments) Commitments, 
                   SUM(CumulatedCalls) CumulatedCalls, 
                   SUM(Distributions) Distributions, 
                   DateLastNAV, 
                   LastNAV
            FROM
            (
                SELECT lp.VehicleID, 
                       LimitedPartnerID, 
                       v.Name FundName, 
                       ModuleID, 
                       ObjectID,
                       CASE
                           WHEN ModuleID = 4
                           THEN
                (
                    SELECT TOP 1 ISNULL(IndividualTitle, '') + ' ' + ISNULL(IndividualLastName, '') + ' ' + ISNULL(IndividualFirstName, '') + ' ' + ISNULL(IndividualMiddleName, '')
                    FROM tbl_ContactIndividual i
                    WHERE i.individualid = ObjectID
                )
                           WHEN ModuleID = 5
                           THEN
                (
                    SELECT TOP 1 companyname
                    FROM tbl_companycontact c
                    WHERE c.companycontactid = ObjectID
                )
                       END LPname,
                       CASE
                           WHEN ModuleID = 4
                           THEN 'Individual'
                           WHEN ModuleID = 5
                           THEN 'Company'
                       END LPType, 
                (
                    SELECT SUM(Amount)
                    FROM tbl_limitedpartner a
                         JOIN tbl_limitedpartnerdetail b ON a.LimitedPartnerID = b.LimitedPartnerID
                    WHERE a.VehicleID = v.vehicleID
                          AND a.ObjectID = lp.ObjectID
                          AND a.ModuleID = lp.ModuleID
                ) Commitments, 
                (
                    SELECT SUM(Amount)
                    FROM tbl_capitalcall a
                         JOIN tbl_CapitalCallLimitedPartner b ON a.CapitalCallID = b.CapitalCallID
                    WHERE a.fundID = lp.vehicleID
                          AND b.LimitedPartnerID IN
                    (
                        SELECT LimitedPartnerID
                        FROM tbl_LimitedPartner aa
                        WHERE aa.VehicleID = lp.VehicleID
                              AND aa.ObjectID = lp.ObjectID
                              AND aa.ModuleID = lp.ModuleID
                    )
                ) CumulatedCalls, 
                (
                    SELECT SUM(Amount)
                    FROM tbl_distribution a
                         JOIN tbl_DistributionLimitedPartner b ON a.DistributionID = b.DistributionID
                    WHERE a.fundID = lp.vehicleID
                          AND b.LimitedPartnerID IN
                    (
                        SELECT LimitedPartnerID
                        FROM tbl_LimitedPartner aa
                        WHERE aa.VehicleID = lp.VehicleID
                              AND aa.ObjectID = lp.ObjectID
                              AND aa.ModuleID = lp.ModuleID
                    )
                ) Distributions, 
                (
                    SELECT SUM(Amount)
                    FROM tbl_VehicleNavLimitedPartner b
                    WHERE b.VehicleNavID =
                    (
                        SELECT TOP 1 a.VehicleNavID
                        FROM tbl_VehicleNav a
                        WHERE a.vehicleID = lp.vehicleID
                        ORDER BY a.NavDate DESC
                    )
                          AND b.LimitedPartnerID IN
                    (
                        SELECT LimitedPartnerID
                        FROM tbl_LimitedPartner aa
                        WHERE aa.VehicleID = lp.VehicleID
                              AND aa.ObjectID = lp.ObjectID
                              AND aa.ModuleID = lp.ModuleID
                    )
                ) LastNAV, 
                (
                    SELECT TOP 1 NavDate
                    FROM tbl_VehicleNav a
                         JOIN tbl_VehicleNavLimitedPartner b ON a.VehicleNavID = b.VehicleNavID
                    WHERE a.vehicleID = lp.vehicleID
                          AND b.LimitedPartnerID IN
                    (
                        SELECT LimitedPartnerID
                        FROM tbl_LimitedPartner aa
                        WHERE aa.VehicleID = lp.VehicleID
                              AND aa.ObjectID = lp.ObjectID
                              AND aa.ModuleID = lp.ModuleID
                    )
                    ORDER BY a.NavDate DESC
                ) DateLastNAV
                FROM tbl_LimitedPartner lp
                     JOIN tbl_vehicle v ON v.vehicleID = lp.vehicleID
            ) t
            GROUP BY VehicleID, 
                     FundName, 
                     LPname, 
                     LPType, 
                     ModuleID, 
                     ObjectID, 
                     DateLastNAV, 
                     LastNAV, 
                     LimitedPartnerID
        ) t
        LEFT JOIN tbl_companyindividuals ci ON ci.CompanyContactID = t.ObjectID
                                               AND t.ModuleID = 5
        LEFT JOIN tbl_companyoffice co ON co.companycontactid = t.objectid
                                          AND t.moduleid = 5
                                          AND co.ismain = 1
                                          AND ci.isMainIndividual = 1
        LEFT JOIN tbl_contactindividual conind ON conind.individualid = t.objectid
                                                  AND t.moduleid = 4
        LEFT JOIN tbl_Nationality n ON n.IndividualID = conind.individualid
        LEFT JOIN tbl_contactindividual cc ON cc.individualid = ci.ContactIndividualID
        LEFT JOIN tbl_lpperformance per ON per.ObjectID = t.objectid
                                           AND per.ModuleID = t.ModuleID
                                           AND per.vehicleID = t.VehicleID
        LEFT JOIN tbl_CompanyOptional cop ON cop.CompanyID = t.ObjectID
                                             AND t.ModuleID = 5
        LEFT JOIN tbl_LPEmailConfig lpe ON lpe.ObjectID = t.ObjectID
                                           AND lpe.ModuleID = t.ModuleID
                                           AND t.VehicleID = lpe.VehicleID
        LEFT JOIN tbl_Vehicle v ON v.VehicleID = lpe.VehicleID
        ORDER BY FundName, 
                 LPName;
    END;
