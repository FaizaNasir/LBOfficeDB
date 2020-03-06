CREATE PROC [dbo].[BI_Deals_JS]
AS
    BEGIN
        SELECT TOP 100 --'----General123456----' '----General----', 

        d.DealName, 
        ISNULL(dbo.[F_GetDealVehicle](d.dealid), '') 'LinkedFund', 
        ReceivedDate 'ReceivedOn', 
        ISNULL(
        (
            SELECT ProjectTypeTitle
            FROM tbl_DealType dt
            WHERE dt.ProjectTypeID = d.DealTypeID
        ), '') [Type], 
        d.Valuation 'EnterpriseValue', 
        d.Sale Sales, 
        d.DealSize 'TotalEquityValue', 
        ISNULL(d.Notes, '') 'DealNotes',

        --'----Target----' '----Target----', 

        ISNULL(cc.CompanyName, '') 'TargetName', 
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
        ISNULL(cc.CompanyBusinessDesc, '') 'BusinessProfile', 
        cc.CompanyComments Notes, 
        ISNULL(
        (
            SELECT countryname
            FROM tbl_country c
            WHERE c.countryid = co.CountryID
        ), '') Country, 
        bcoun.ISO 'TargetCountryISO', 
        bcoun.ISO2 'TargetCountryISO2', 
        co.OfficeAddress Address, 
        co.OfficeCity City, 
        ISNULL(
        (
            SELECT StateTitle
            FROM tbl_state s
            WHERE s.StateID = co.StateID
        ), '') State, 
        co.OfficeZip 'ZipCode', 
        ISNULL(bcoun.countryphonecode, '') + ' ' + co.OfficePhone Phone, 
        ISNULL(bcoun.countryphonecode, '') + ' ' + co.OfficeFax Fax, 
        cc.CompanyWebSite WebSite, 
        cc.CompanyCreationDate 'CreationDate', 
        cc.CompanyStartCollaborationDate 'StartCollaborationDate',
        --'----Optional----' '----Optional----', 
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
        do.CloseDate 'ClosingDate', 
        do.SignedOn 'NDASignedOn',
        CASE
            WHEN do.NDATypeID = 1
            THEN 'Listed'
            WHEN do.NDATypeID = 0
            THEN ' Not Listed'
            ELSE ''
        END 'NDAType', 
        TenorOfEngagement 'LockingPeriod', 
        DATEADD(month, ISNULL(TenorOfEngagement, 0), do.SignedOn) 'ExpiryDate', 
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
        ), '') 'SourceType', 
        ISNULL(do.InvestmentReason, '') 'DealThesis', 
        ISNULL(
        (
            SELECT DealInvestmentBackgroundName
            FROM tbl_DealInvestmentBackground dib
            WHERE dib.DealInvestmentBackgroundID = do.InvestmentBackgroundID
        ), '') 'TransactionReason', 
        ISNULL(do.ExpectedExit, '') 'ExpectedPlan',
        CASE
            WHEN do.IsCommunicated = 1
            THEN 'Yes'
            WHEN do.IsCommunicated = 0
            THEN 'No'
            ELSE ''
        END KYCDone, 
        ISNULL(
        (
            SELECT ProjectStatusTitle
            FROM tbl_DealStatus ds
            WHERE ds.ProjectStatusID = dstg.DealStatusID
        ), '') 'LastStage', 
        ISNULL(dstg.Validation, '') 'LastStageValidation', 
        dstg.DealStatusDateTime 'LastStagedate', 
        ISNULL(dstg.DealStatusComments, '') 'LastStageNotes', 
        ISNULL(
        (
            SELECT ProjectStatusTitle
            FROM tbl_DealStatus ds
            WHERE ds.ProjectStatusID = dlstg.DealStatusID
        ), '') 'BeforeLastStage', 
        ISNULL(dlstg.Validation, '') 'BeforeLastStageValidation', 
        dlstg.DealStatusDateTime 'BeforeLastStageDate', 
        ISNULL(dlstg.DealStatusComments, '') 'BeforeLastStageNotes',

        --'----Contacts----' '----Contacts----', 

        ISNULL(dbo.F_DealTeamMember(d.dealid, NULL), '') 'DealTeamMembers', 
        ISNULL(dbo.F_DealTeamMember(d.dealid, 1), '') 'TeamLead', 
        ISNULL(
        (
            SELECT i.IndividualFullName
            FROM tbl_ContactIndividual i
            WHERE i.individualid = d.ReceiverId
        ), '') 'ReceivedBy', 
        ccd.CompanyName 'SponsorFund', 
        ISNULL(
        (
            SELECT TOP 1 con.ISO
            FROM tbl_CompanyOffice co
                 JOIN tbl_Country con ON con.CountryID = co.CountryID
            WHERE ccd.CompanyContactID = co.CompanyContactID
                  AND co.IsMain = 1
        ), '') 'SponsorFundCountryISO', 
        ISNULL(
        (
            SELECT TOP 1 con.ISO2
            FROM tbl_CompanyOffice co
                 JOIN tbl_Country con ON con.CountryID = co.CountryID
            WHERE ccd.CompanyContactID = co.CompanyContactID
                  AND co.IsMain = 1
        ), '') 'SponsorFundCountryISO2', 
        ISNULL(
        (
            SELECT c.CompanyName
            FROM tbl_CompanyContact c
            WHERE c.companycontactid = d.DealSourceCompanyID
        ), '') 'SourceCompany', 
        ISNULL(
        (
            SELECT TOP 1 con.ISO
            FROM tbl_CompanyContact c
                 JOIN tbl_CompanyOffice co ON c.CompanyContactID = co.CompanyContactID
                                              AND co.IsMain = 1
                 JOIN tbl_Country con ON con.CountryID = co.CountryID
            WHERE c.companycontactid = d.DealSourceCompanyID
        ), '') 'SourceCompanyCountryISO', 
        ISNULL(
        (
            SELECT i.IndividualFullName
            FROM tbl_ContactIndividual i
            WHERE i.individualid = d.DealSourceIndividualID
        ), '') 'SourceIndividual',

        --'----Contacts----' '----Contacts----', 

        ISNULL(i.IndividualTitle, '') Title, 
        ISNULL(i.IndividualFirstName, '') 'FirstName', 
        ISNULL(i.IndividualLastName, '') 'LastName', 
        ISNULL(
        (
            SELECT OfficeCity
            FROM tbl_companyoffice ico
            WHERE ico.officeid = ci.OfficeID
        ), '') 'OfficeCity',
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
        ci.ContactDateOfJoiningInCompany 'JoinOn', 
        ci.ContactDateOfLeavingFromCompany 'LeftOn',
        CASE
            WHEN ci.isMainCompany = 1
            THEN 'Yes'
            ELSE ''
        END 'IsMainCompany',
        CASE
            WHEN ci.IsMainIndividual = 1
                 AND TeamTypeName = 'Executive Team'
            THEN 'Yes'
            ELSE ''
        END 'IsMainIndividual'
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
