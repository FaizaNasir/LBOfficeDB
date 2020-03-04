CREATE PROC [dbo].[BI_Deals]
AS
    BEGIN
        SELECT '----General----' '----General----', 
               d.DealName 'Deal name', 
               ISNULL(dbo.[F_GetDealVehicle](d.dealid), '') 'Linked fund', 
               ReceivedDate 'Received on', 
               ISNULL(
        (
            SELECT ProjectTypeTitle
            FROM tbl_DealType dt
            WHERE dt.ProjectTypeID = d.DealTypeID
        ), '') [Type], 
               d.Valuation 'Enterprise value', 
               d.Sale Sales, 
               d.DealSize 'Total equity value', 
               ISNULL(d.Notes, '') 'Deal notes', 
               '----Target----' '----Target----', 
               cc.CompanyContactID 'ID', 
               ISNULL(cc.CompanyName, '') 'Target name', 
               ISNULL(
        (
            SELECT BusinessAreaTitle
            FROM tbl_BusinessArea ba
            WHERE ba.BusinessAreaID = cc.CompanyBusinessAreaID
        ), '') Sector, 
               ISNULL(
        (
            SELECT CompanyIndustryTitle
            FROM tbl_CompanyIndustries ind
            WHERE ind.CompanyIndustryID = cc.CompanyIndustryID
        ), '') Industry, 
               ISNULL(cc.CompanyBusinessDesc, '') 'Business profile', 
               cc.CompanyComments Notes, 
               ISNULL(
        (
            SELECT countryname
            FROM tbl_country c
            WHERE c.countryid = co.CountryID
        ), '') Country, 
               bcoun.ISO 'Target country ISO', 
               bcoun.ISO2 'Target country ISO2', 
               co.OfficeAddress Address, 
               co.OfficeCity City, 
               ISNULL(
        (
            SELECT StateTitle
            FROM tbl_state s
            WHERE s.StateID = co.StateID
        ), '') State, 
               co.OfficeZip 'Zip code', 
               ISNULL(bcoun.countryphonecode, '') + ' ' + co.OfficePhone Phone, 
               ISNULL(bcoun.countryphonecode, '') + ' ' + co.OfficeFax Fax, 
               cc.CompanyWebSite WebSite, 
               cc.CompanyCreationDate 'Creation date', 
               cc.CompanyStartCollaborationDate 'Start collaboration date',
               CASE
                   WHEN LEN(ISNULL(cc.CompanyLogo, '')) = 0
                   THEN ''
                   ELSE 'https://one.davigold.com/LBOPicturelib/' + cc.CompanyLogo
               END 'Company logo', 
               '----Optional----' '----Optional----', 
               ISNULL(CASE
                          WHEN do.DealPriority = 1
                          THEN 'Co-invest w/ fees and/or carry'
                          WHEN do.DealPriority = 2
                          THEN 'Minority transaction, no control shareholder'
                          WHEN do.DealPriority = 3
                          THEN 'Lead / Co Lead'
                          WHEN do.DealPriority = 4
                          THEN 'Public investment'
                          WHEN do.DealPriority = 5
                          THEN 'Co-invest no fees, no carry'
                          WHEN do.DealPriority = 6
                          THEN 'No alignment of interest / structured product'
                      END, '') Category, 
               do.CloseDate 'Closing date', 
               do.SignedOn 'NDA signed on',
               CASE
                   WHEN do.NDATypeID = 1
                   THEN 'Listed'
                   WHEN do.NDATypeID = 0
                   THEN ' Not Listed'
                   ELSE ''
               END 'NDA type', 
               TenorOfEngagement 'Locking period', 
               DATEADD(month, ISNULL(TenorOfEngagement, 0), do.SignedOn) 'Expiry date', 
               ISNULL(
        (
            SELECT DealOwnershipName
            FROM tbl_DealOwnership down
            WHERE down.DealOwnershipID = do.OwnershipID
        ), '') Ownership, 
               ISNULL(
        (
            SELECT DealSourceTypeName
            FROM tbl_DealSourceType dst
            WHERE dst.DealSourceTypeID = do.SourceTypeID
        ), '') 'Source type', 
               ISNULL(do.InvestmentReason, '') 'Deal thesis', 
               ISNULL(
        (
            SELECT DealInvestmentBackgroundName
            FROM tbl_DealInvestmentBackground dib
            WHERE dib.DealInvestmentBackgroundID = do.InvestmentBackgroundID
        ), '') 'Transaction reason', 
               ISNULL(do.ExpectedExit, '') 'Expected plan',
               CASE
                   WHEN do.IsCommunicated = 1
                   THEN 'Yes'
                   WHEN do.IsCommunicated = 0
                   THEN 'No'
                   ELSE ''
               END KYCDone, 
               '----Stage----' '----Stage----', 
               ISNULL(
        (
            SELECT ProjectStatusTitle
            FROM tbl_DealStatus ds
            WHERE ds.ProjectStatusID = dstg.DealStatusID
        ), '') 'Last stage', 
               ISNULL(dstg.Validation, '') 'Last stage validation', 
               dstg.DealStatusDateTime 'Last stage date', 
               ISNULL(dstg.DealStatusComments, '') 'Last stage notes', 
               ISNULL(
        (
            SELECT ProjectStatusTitle
            FROM tbl_DealStatus ds
            WHERE ds.ProjectStatusID = dlstg.DealStatusID
        ), '') 'Before last stage', 
               ISNULL(dlstg.Validation, '') 'Before last stage validation', 
               dlstg.DealStatusDateTime 'Before last stage date', 
               ISNULL(dlstg.DealStatusComments, '') 'Before last stage notes', 
               '----Contacts----' '----Contacts----', 
               ISNULL(dbo.F_DealTeamMember(d.dealid, NULL), '') 'Deal team members', 
               ISNULL(dbo.F_DealTeamMember(d.dealid, 1), '') 'Team lead', 
               ISNULL(
        (
            SELECT i.IndividualFullName
            FROM tbl_ContactIndividual i
            WHERE i.individualid = d.ReceiverId
        ), '') 'Received by', 
               ccd.CompanyContactID 'Sponsor fund ID', 
               ccd.CompanyName 'Sponsor fund', 
               ISNULL(
        (
            SELECT con.ISO
            FROM tbl_CompanyOffice co
                 JOIN tbl_Country con ON con.CountryID = co.CountryID
            WHERE ccd.CompanyContactID = co.CompanyContactID
                  AND co.IsMain = 1
        ), '') 'Sponsor fund country ISO', 
               ISNULL(
        (
            SELECT con.ISO2
            FROM tbl_CompanyOffice co
                 JOIN tbl_Country con ON con.CountryID = co.CountryID
            WHERE ccd.CompanyContactID = co.CompanyContactID
                  AND co.IsMain = 1
        ), '') 'Sponsor fund country ISO2', 
               ISNULL(
        (
            SELECT c.CompanyName
            FROM tbl_CompanyContact c
            WHERE c.companycontactid = d.DealSourceCompanyID
        ), '') 'Source company', 
               ISNULL(
        (
            SELECT con.ISO
            FROM tbl_CompanyContact c
                 JOIN tbl_CompanyOffice co ON c.CompanyContactID = co.CompanyContactID
                                              AND co.IsMain = 1
                 JOIN tbl_Country con ON con.CountryID = co.CountryID
            WHERE c.companycontactid = d.DealSourceCompanyID
        ), '') 'Source company country ISO', 
               ISNULL(
        (
            SELECT i.IndividualFullName
            FROM tbl_ContactIndividual i
            WHERE i.individualid = d.DealSourceIndividualID
        ), '') 'Source individual', 
               '----Contacts----' '----Contacts----', 
               ISNULL(i.IndividualTitle, '') Title, 
               ISNULL(i.IndividualFirstName, '') 'First name', 
               ISNULL(i.IndividualLastName, '') 'Last name', 
               ISNULL(
        (
            SELECT OfficeCity
            FROM tbl_companyoffice ico
            WHERE ico.officeid = ci.OfficeID
        ), '') 'Office city',
               CASE
                   WHEN TeamTypeName = 'Adivsory Board'
                   THEN 'Advisory Board'
                   ELSE TeamTypeName
               END 'TeamType', 
               ISNULL(CASE
                          WHEN TeamTypeName = 'Adivsory Board'
                          THEN ci.ContactRole
                          ELSE ci.ContactPositionInCompany
                      END, '') Position, 
               ISNULL(ci.ContactDepartmentInCompany, '') Department, 
               ci.ContactDateOfJoiningInCompany 'Join on', 
               ci.ContactDateOfLeavingFromCompany 'Left on',
               CASE
                   WHEN ci.isMainCompany = 1
                   THEN 'Yes'
                   ELSE ''
               END 'Is main company',
               CASE
                   WHEN ci.IsMainIndividual = 1
                        AND TeamTypeName = 'Executive Team'
                   THEN 'Yes'
                   ELSE ''
               END 'Is main individual'
        FROM tbl_deals d
             LEFT JOIN tbl_DealOptionalDetails do ON do.dealid = d.DealID
             LEFT JOIN tbl_companycontact cc ON cc.companycontactid = d.DealCurrentTargetID
             LEFT JOIN tbl_CompanyIndividuals ci ON cc.companycontactid = ci.CompanyContactID
             LEFT JOIN tbl_ContactIndividual i ON i.individualid = ci.ContactIndividualID
             LEFT JOIN tbl_CompanyOffice co ON co.CompanyContactID = cc.CompanyContactID
                                               AND co.IsMain = 1
             LEFT JOIN tbl_country Bcoun ON Bcoun.countryid = co.countryID
             LEFT JOIN tbl_DealCompany dc ON dc.DealID = d.DealID
             LEFT JOIN tbl_companycontact ccd ON ccd.Companycontactid = dc.CompanyID
             OUTER APPLY
        (
            SELECT TOP 1 ds.*
            FROM tbl_DealStatusDetails ds
            WHERE ds.DealID = d.DealID
            ORDER BY ds.DealStatusDetailsID DESC
        ) AS dstg
             OUTER APPLY
        (
            SELECT TOP 1 dls.*
            FROM tbl_DealStatusDetails dls
            WHERE dls.DealID = d.DealID
                  AND dls.DealStatusDetailsID < dstg.DealStatusDetailsID
            ORDER BY dls.DealStatusDetailsID DESC
        ) AS dlstg;
    END;
