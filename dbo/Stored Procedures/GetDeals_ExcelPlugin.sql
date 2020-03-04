CREATE PROC [dbo].[GetDeals_ExcelPlugin]
AS
    BEGIN
        SELECT *,
               CASE
                   WHEN StatusCSV LIKE '%Opportunity received%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Opportunity received exists',
               CASE
                   WHEN StatusCSV LIKE '%Due diligence%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Due diligence exists',
               CASE
                   WHEN StatusCSV LIKE '%Pre-committee%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Pre-committee exists',
               CASE
                   WHEN StatusCSV LIKE '%Compliance / KYC review%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Compliance / KYC review exists',
               CASE
                   WHEN StatusCSV LIKE '%Investment decision FPCI%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Investment decision FPCI exists',
               CASE
                   WHEN StatusCSV LIKE '%Review by risk manager FPCI%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Review by risk manager FPCI exists',
               CASE
                   WHEN StatusCSV LIKE '%Review by risk manager SICAR%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Review by risk manager SICAR exists',
               CASE
                   WHEN StatusCSV LIKE '%Investment decision SICAR%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Investment decision SICAR exists',
               CASE
                   WHEN StatusCSV LIKE '%Final review by FPCI Board%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Final review by FPCI Board exists',
               CASE
                   WHEN StatusCSV LIKE '%Final review by SICAR Board%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Final review by SICAR Board exists',
               CASE
                   WHEN StatusCSV LIKE '%Signing%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Signing exists',
               CASE
                   WHEN StatusCSV LIKE '%Closing FPCI%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Closing FPCI exists',
               CASE
                   WHEN StatusCSV LIKE '%Closing SICAR%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Closing SICAR exists',
               CASE
                   WHEN StatusCSV LIKE '%Rejected by EdR%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Rejected by EdR exists',
               CASE
                   WHEN StatusCSV LIKE '%Rejected by the target%'
                   THEN 'Yes'
                   ELSE 'No'
               END 'Is Rejected by the target exists'
        FROM
        (
            SELECT DISTINCT 
                   dbo.[F_GetDealStatusCSV](d.DealID) StatusCSV, 
                   d.DealID, 
                   d.DealName 'Deal name', 
                   d.DealCurrencyCode Currency, 
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
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstgLast.DealStatusID
            ), '') 'Last Stage', 
                   ISNULL(dstgLast.Validation, '') 'Last Stage validation', 
                   dstgLast.DealStatusDateTime 'Last Stage date', 
                   ISNULL(dstgLast.DealStatusComments, '') 'Last Stage notes', 
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstg1.DealStatusID
            ), '') 'Stage1', 
                   ISNULL(dstg1.Validation, '') 'Stage1 validation', 
                   dstg1.DealStatusDateTime 'Stage1 date', 
                   ISNULL(dstg1.DealStatusComments, '') 'Stage1 notes', 
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstg2.DealStatusID
            ), '') 'Stage2', 
                   ISNULL(dstg2.Validation, '') 'Stage2 validation', 
                   dstg2.DealStatusDateTime 'Stage2 date', 
                   ISNULL(dstg2.DealStatusComments, '') 'Stage2 notes', 
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstg3.DealStatusID
            ), '') 'Stage3', 
                   ISNULL(dstg3.Validation, '') 'Stage3 validation', 
                   dstg3.DealStatusDateTime 'Stage3 date', 
                   ISNULL(dstg3.DealStatusComments, '') 'Stage3 notes', 
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstg4.DealStatusID
            ), '') 'Stage4', 
                   ISNULL(dstg4.Validation, '') 'Stage4 validation', 
                   dstg4.DealStatusDateTime 'Stage4 date', 
                   ISNULL(dstg4.DealStatusComments, '') 'Stage4 notes', 
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstg5.DealStatusID
            ), '') 'Stage5', 
                   ISNULL(dstg5.Validation, '') 'Stage5 validation', 
                   dstg5.DealStatusDateTime 'Stage5 date', 
                   ISNULL(dstg5.DealStatusComments, '') 'Stage5 notes', 
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstg6.DealStatusID
            ), '') 'Stage6', 
                   ISNULL(dstg6.Validation, '') 'Stage6 validation', 
                   dstg6.DealStatusDateTime 'Stage6 date', 
                   ISNULL(dstg6.DealStatusComments, '') 'Stage6 notes', 
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstg7.DealStatusID
            ), '') 'Stage7', 
                   ISNULL(dstg7.Validation, '') 'Stage7 validation', 
                   dstg7.DealStatusDateTime 'Stage7 date', 
                   ISNULL(dstg7.DealStatusComments, '') 'Stage7 notes', 
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstg8.DealStatusID
            ), '') 'Stage8', 
                   ISNULL(dstg8.Validation, '') 'Stage8 validation', 
                   dstg8.DealStatusDateTime 'Stage8 date', 
                   ISNULL(dstg8.DealStatusComments, '') 'Stage8 notes', 
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstg9.DealStatusID
            ), '') 'Stage9', 
                   ISNULL(dstg9.Validation, '') 'Stage9 validation', 
                   dstg9.DealStatusDateTime 'Stage9 date', 
                   ISNULL(dstg9.DealStatusComments, '') 'Stage9 notes', 
                   ISNULL(
            (
                SELECT ProjectStatusTitle
                FROM tbl_DealStatus ds
                WHERE ds.ProjectStatusID = dstg10.DealStatusID
            ), '') 'Stage10', 
                   ISNULL(dstg10.Validation, '') 'Stage10 validation', 
                   dstg10.DealStatusDateTime 'Stage10 date', 
                   ISNULL(dstg10.DealStatusComments, '') 'Stage10 notes', 
                   ISNULL(dbo.F_DealTeamMember(d.dealid, NULL), '') 'Deal team members', 
                   ISNULL(dbo.F_DealTeamMember(d.dealid, 1), '') 'Team lead', 
                   ISNULL(
            (
                SELECT i.IndividualFullName
                FROM tbl_ContactIndividual i
                WHERE i.individualid = d.ReceiverId
            ), '') 'Received by', 
                   dbo.F_GetSponserFund(d.dealid) 'Sponsor fund', 
                   ISNULL(
            (
                SELECT c.CompanyName
                FROM tbl_CompanyContact c
                WHERE c.companycontactid = d.DealSourceCompanyID
            ), '') 'Source company', 
                   ISNULL(
            (
                SELECT i.IndividualFullName
                FROM tbl_ContactIndividual i
                WHERE i.individualid = d.DealSourceIndividualID
            ), '') 'Source individual'
            FROM tbl_deals d
                 LEFT JOIN tbl_DealOptionalDetails do ON do.dealid = d.DealID
                 LEFT JOIN tbl_companycontact cc ON cc.companycontactid = d.DealCurrentTargetID
                 LEFT JOIN tbl_CompanyOffice co ON co.CompanyContactID = cc.CompanyContactID
                                                   AND co.IsMain = 1
                 LEFT JOIN tbl_country Bcoun ON Bcoun.countryid = co.countryID
                 OUTER APPLY
            (
                SELECT TOP 1 ds.*
                FROM tbl_DealStatusDetails ds
                WHERE ds.DealID = d.DealID
                ORDER BY ds.DealStatusDateTime DESC
            ) AS dstgLast
                 OUTER APPLY
            (
                SELECT TOP 1 ds.*
                FROM tbl_DealStatusDetails ds
                WHERE ds.DealID = d.DealID
                ORDER BY ds.DealStatusDateTime, 
                         DealStatusDetailsID
            ) AS dstg1
                 OUTER APPLY
            (
                SELECT TOP 1 dls.*
                FROM tbl_DealStatusDetails dls
                WHERE dls.DealID = d.DealID
                      AND dls.DealStatusDetailsID > dstg1.DealStatusDetailsID
                ORDER BY dls.DealStatusDateTime, 
                         DealStatusDetailsID
            ) AS dstg2
                 OUTER APPLY
            (
                SELECT TOP 1 dls.*
                FROM tbl_DealStatusDetails dls
                WHERE dls.DealID = d.DealID
                      AND dls.DealStatusDetailsID > dstg2.DealStatusDetailsID
                ORDER BY dls.DealStatusDateTime, 
                         DealStatusDetailsID
            ) AS dstg3
                 OUTER APPLY
            (
                SELECT TOP 1 dls.*
                FROM tbl_DealStatusDetails dls
                WHERE dls.DealID = d.DealID
                      AND dls.DealStatusDetailsID > dstg3.DealStatusDetailsID
                ORDER BY dls.DealStatusDateTime, 
                         DealStatusDetailsID
            ) AS dstg4
                 OUTER APPLY
            (
                SELECT TOP 1 dls.*
                FROM tbl_DealStatusDetails dls
                WHERE dls.DealID = d.DealID
                      AND dls.DealStatusDetailsID > dstg4.DealStatusDetailsID
                ORDER BY dls.DealStatusDateTime, 
                         DealStatusDetailsID
            ) AS dstg5
                 OUTER APPLY
            (
                SELECT TOP 1 dls.*
                FROM tbl_DealStatusDetails dls
                WHERE dls.DealID = d.DealID
                      AND dls.DealStatusDetailsID > dstg5.DealStatusDetailsID
                ORDER BY dls.DealStatusDateTime, 
                         DealStatusDetailsID
            ) AS dstg6
                 OUTER APPLY
            (
                SELECT TOP 1 dls.*
                FROM tbl_DealStatusDetails dls
                WHERE dls.DealID = d.DealID
                      AND dls.DealStatusDetailsID > dstg6.DealStatusDetailsID
                ORDER BY dls.DealStatusDateTime, 
                         DealStatusDetailsID
            ) AS dstg7
                 OUTER APPLY
            (
                SELECT TOP 1 dls.*
                FROM tbl_DealStatusDetails dls
                WHERE dls.DealID = d.DealID
                      AND dls.DealStatusDetailsID > dstg7.DealStatusDetailsID
                ORDER BY dls.DealStatusDateTime, 
                         DealStatusDetailsID
            ) AS dstg8
                 OUTER APPLY
            (
                SELECT TOP 1 dls.*
                FROM tbl_DealStatusDetails dls
                WHERE dls.DealID = d.DealID
                      AND dls.DealStatusDetailsID > dstg8.DealStatusDetailsID
                ORDER BY dls.DealStatusDateTime, 
                         DealStatusDetailsID
            ) AS dstg9
                 OUTER APPLY
            (
                SELECT TOP 1 dls.*
                FROM tbl_DealStatusDetails dls
                WHERE dls.DealID = d.DealID
                      AND dls.DealStatusDetailsID > dstg9.DealStatusDetailsID
                ORDER BY dls.DealStatusDateTime, 
                         DealStatusDetailsID
            ) AS dstg10
        ) t
        ORDER BY [Deal name];
    END;
