CREATE PROCEDURE [dbo].[proc_Deals_Report_GET]
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @tblDealTeam AS TABLE
        (DealID         INT, 
         IndividualID   INT, 
         IndividualName VARCHAR(MAX)
        );
        INSERT INTO @tblDealTeam
               SELECT dt.DealID, 
                      dt.IndividualID, 
                      ci.IndividualFullName
               FROM tbl_dealteam dt
                    JOIN tbl_deals td ON dt.DealID = td.DealID
                    LEFT JOIN tbl_ContactIndividual ci ON ci.IndividualID = dt.IndividualID;
        SELECT DealID, 
               DealTeam = STUFF(
        (
            SELECT ', ' + CAST(IndividualName AS VARCHAR)
            FROM @tblDealTeam b
            WHERE b.DealID = a.DealID FOR XML PATH('')
        ), 1, 2, '')
        INTO #DealTeam
        FROM @tblDealTeam a
        GROUP BY DealID;
        SELECT lst.DealID, 
               lst.ProjectStatusTitle AS [Deal last stage], 
               lst.[Validation] AS [Last stage validation], 
               CONVERT(VARCHAR(10), lst.DealStatusDateTime, 101) AS [Last stage date], 
               lst.DealStatusComments AS [Last stage comments], 
               before.ProjectStatusTitle AS [Deal before last stage], 
               before.[Validation] AS [Before last stage validation], 
               CONVERT(VARCHAR(10), before.DealStatusDateTime, 101) AS [Before last stage date], 
               before.DealStatusComments AS [Before last stage comments]
        INTO #DealStages
        FROM
        (
            SELECT *
            FROM
            (
                SELECT 'last' AS [status], 
                       ROW_NUMBER() OVER(PARTITION BY td.dealid
                       ORDER BY td.DealID, 
                                sts.CreateDateTime DESC) rownum, 
                       td.DealID, 
                       dstat.ProjectStatusTitle, 
                       [Validation], 
                       DealStatusDateTime, 
                       DealStatusComments
                FROM tbl_deals td
                     JOIN tbl_DealStatusDetails sts ON td.DealID = sts.DealID
                     JOIN tbl_DealStages ds ON ds.DealStageID = td.DealStageID
                     LEFT JOIN tbl_DealStatus dstat ON dstat.ProjectStatusID = td.DealStatusID
            ) c
            WHERE rownum = 1
        ) lst
        LEFT JOIN
        (
            SELECT *
            FROM
            (
                SELECT 'before' AS [status], 
                       ROW_NUMBER() OVER(PARTITION BY td.dealid
                       ORDER BY td.DealID, 
                                sts.CreateDateTime DESC) rownum, 
                       td.DealID, 
                       dstat.ProjectStatusTitle, 
                       [Validation], 
                       DealStatusDateTime, 
                       DealStatusComments
                FROM tbl_deals td
                     JOIN tbl_DealStatusDetails sts ON td.DealID = sts.DealID
                     JOIN tbl_DealStages ds ON ds.DealStageID = td.DealStageID
                     LEFT JOIN tbl_DealStatus dstat ON dstat.ProjectStatusID = td.DealStatusID
            ) d
            WHERE rownum = 2
        ) before ON lst.dealid = before.dealid;
        SELECT DISTINCT --D.DealID,

               D.DealName AS [Deal Name], 
               V.Name AS [Deal Linked Fund], 
               DT.ProjectTypeDesc AS [Deal type], 
               CONVERT(VARCHAR(10), D.ReceivedDate, 101) AS [Date received], 
               D.DealCurrencyCode AS [Deal currency], 
               D.Sale AS [Sale (M)], 
               D.DealSize AS [Deal size], 
               D.Valuation AS [Enterprise value], 
               D.Notes AS [Deal notes], 
               cc.CompanyName AS [Target name], 
               CC.CompanyLogo AS [Target logo], 
               BA.BusinessAreaTitle AS [Target sector], 
               CInd.CompanyIndustryTitle AS [Target industry], 
               CC.CompanyBusinessDesc AS [Target business profile], --'' as [Target Executive team],

               CC.CompanyAddress AS [Target address], 
               ComCity.CityName AS [Target city], 
               CC.CompanyZip AS [Target zip code], 
               ComCnty.CountryName AS [Target country], 
               cc.CompanyPhone AS [Target phone number], 
               CC.CompanyFax AS [Target fax number], 
               CC.CompanyWebSite AS [Target website], 
               CC.CompanyComments AS [Target notes], 
               (CASE
                    WHEN DealPriority = 1
                    THEN 'Co-invest'
                    WHEN DealPriority = 2
                    THEN 'Consortium'
                    WHEN DealPriority = 3
                    THEN 'Lead /Co Lead'
                    WHEN DealPriority = 4
                    THEN 'Public investment'
                END) AS [Deal category], 
               DealIntroductionWithName AS [Introduced with], 
               DealSourceTypeName AS [Source type], 
               (CASE
                    WHEN NDATypeID = 1
                    THEN 'Listed'
                    WHEN NDATypeID = 2
                    THEN 'Not Listed'
                    ELSE ''
                END) AS [NDA type], 
               (CASE
                    WHEN DO.InvestmentBackgroundID = 1
                    THEN 'Succession issue'
                    WHEN DO.InvestmentBackgroundID = 2
                    THEN 'Private shareholders willing to realize their assets'
                    WHEN DO.InvestmentBackgroundID = 3
                    THEN 'Entrepreneurs willing investment diversification while managing their firm'
                    WHEN DO.InvestmentBackgroundID = 4
                    THEN 'Exit of non-strategic subsidiaries of a Group'
                END) AS [Transaction reason], 
               CONVERT(VARCHAR(10), CloseDate, 101) AS [Closing date], 
               DealOwnershipName AS [Ownership], 
               CONVERT(VARCHAR(10), SignedOn, 101) AS [NDA signed on], 
               DO.ExpectedExit AS [Expected plan], 
               (CASE
                    WHEN DO.IsCommunicated = 1
                    THEN 'Yes'
                    ELSE 'No'
                END) AS [KYC Done], 
               DO.InvestmentReason AS [Deal thesis], 
               DO.TenorOfEngagement AS [locking period], 
               ccsrc.CompanyName AS [Deal sender company], 
               ci.IndividualFullName AS [Deal sender individual], 
               dcc.CompanyName AS [Sponsor Funds], 
               Receiver.IndividualFullName AS [Deal received by], 
               DTM.DealTeam [Deal Team], 
               DLS.DealStageDecs AS [Deal Status], 
               [Deal last stage], 
               [Last stage validation], 
               [Last stage date], 
               [Last stage comments], 
               [Deal before last stage], 
               [Before last stage validation] [Before last stage date], 
               [Before last stage comments]
        FROM dbo.tbl_Deals AS D
             LEFT OUTER JOIN dbo.tbl_DealType AS DT ON D.DealTypeID = DT.ProjectTypeID
             LEFT OUTER JOIN dbo.tbl_DealStatus AS DS ON D.DealStatusID = DS.ProjectStatusID
             LEFT OUTER JOIN dbo.tbl_Office AS O ON D.OfficeID = O.OfficeID
             LEFT OUTER JOIN dbo.tbl_CompanyContact AS CC ON D.DealCurrentTargetID = CC.CompanyContactID
             LEFT OUTER JOIN dbo.tbl_BusinessArea AS BA ON CC.CompanyBusinessAreaID = BA.BusinessAreaID
             LEFT OUTER JOIN dbo.tbl_Country AS C ON CC.CompanyCountryID = C.CountryID
             LEFT OUTER JOIN dbo.tbl_DealTeam AS DP ON D.DealID = DP.DealID
                                                       AND DP.IsTeamLead = 1
             LEFT OUTER JOIN dbo.tbl_DealStages AS DLS ON D.DealStageID = DLS.DealStageID
             LEFT JOIN tbl_Country ComCnty ON ComCnty.CountryID = CC.CompanyCountryID
             LEFT JOIN tbl_City ComCity ON ComCity.CountryID = CC.CompanyCountryID
                                           AND ComCity.CityID = CC.CompanyCityID
             LEFT JOIN tbl_DealOptionalDetails DO ON D.DealID = DO.DealID
             LEFT JOIN tbl_DealSourceType ST ON ST.DealSourceTypeID = DO.SourceTypeID
             LEFT JOIN tbl_DealOwnership DOWN ON DOWN.DealOwnershipID = DO.OwnershipID
             LEFT JOIN tbl_DealIntroductionWith DI ON DI.DealIntroductionWithID = DO.IntroducedWithID
             LEFT JOIN #DealTeam DTM ON DTM.DealID = D.DealID
             LEFT JOIN tbl_CompanyContact CCSRC ON D.DealSourceCompanyID = CCSRC.CompanyContactID
             LEFT JOIN tbl_CompanyContact CCTAR ON D.DealCurrentTargetID = CCTAR.CompanyContactID
             LEFT JOIN tbl_ContactIndividual CI ON CI.IndividualID = D.DealSourceIndividualID
             LEFT JOIN #DealStages DST ON DST.DealID = D.DealID
             LEFT JOIN tbl_DealVehicle DV ON DV.DealId = D.DealID
             LEFT JOIN tbl_Vehicle V ON V.VehicleID = DV.VehicleId
             LEFT JOIN tbl_CompanyIndustries CInd ON CInd.CompanyIndustryID = CC.CompanyIndustryID
             LEFT JOIN tbl_dealcompany dcom ON dcom.DealID = D.DealID
             LEFT JOIN tbl_companycontact dcc ON dcc.CompanyContactID = dcom.CompanyID
             LEFT JOIN tbl_ContactIndividual Receiver ON Receiver.IndividualID = D.ReceiverId
        WHERE ISNULL(D.DealName, '') <> '';
        IF OBJECT_ID('tempdb..#DealStages') IS NOT NULL
            DROP TABLE #DealStages;
        IF OBJECT_ID('tempdb..#DealTeam') IS NOT NULL
            DROP TABLE #DealTeam;
        SET NOCOUNT OFF;
    END;
