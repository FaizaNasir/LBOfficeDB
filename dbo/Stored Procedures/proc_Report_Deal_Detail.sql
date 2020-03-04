CREATE PROCEDURE [dbo].[proc_Report_Deal_Detail] @DealTypeID  VARCHAR(100), 
                                                 @DealStageID VARCHAR(100)
AS
    BEGIN
        SELECT DISTINCT 
               D.DealName AS 'Deal name', 
               DT.ProjectTypeTitle AS 'Deal type', 
               DS.ProjectStatusTitle AS 'Deal stage', 
               D.DealSize, 
               d.DealCurrencyCode, 
               O.OfficeName AS 'Office Name', 
               D.Notes, 
               CC.CompanyName AS TargetName, 
               BA.BusinessAreaTitle AS Sector, 
               C.CountryName AS Country, 
               D.receiveddate AS 'Issue date', 
               dsd.DealStatusDateTime LastStageDate, 
               DS.ProjectStatusTitle LastStage, 
               do.CloseDate, 
               dbo.F_GetDealTeam(d.dealid) DealTeam, 
               dbo.F_GetDealCompany(d.dealid) DealCompany, 
        (
            SELECT TOP 1 companyname
            FROM tbl_companycontact cc
            WHERE companycontactid = DealSourceCompanyID
        ) SourceCompany, 
        (
            SELECT TOP 1 IndividualFullName
            FROM tbl_contactindividual cc
            WHERE IndividualID = DealSourceIndividualID
        ) SourceIndividual, 
        (
            SELECT TOP 1 s.ProjectStatusTitle
            FROM tbl_DealStatus s
                 JOIN tbl_DealStatusDetails ss ON ss.DealStatusID = s.ProjectStatusID
            WHERE ss.DealID = d.dealid
                  AND ss.DealStatusDetailsID < dsd.DealStatusDetailsID
            ORDER BY ss.DealStatusDetailsID DESC
        ) StageBeforeLast
        FROM tbl_deals AS D
             LEFT OUTER JOIN tbl_DealOptionalDetails do ON Do.dealid = d.dealid
             LEFT OUTER JOIN tbl_DealType AS DT ON D.DealTypeID = DT.ProjectTypeID
             LEFT OUTER JOIN tbl_DealStatus AS DS ON D.DealStatusID = DS.ProjectStatusID
             LEFT OUTER JOIN tbl_Office AS O ON D.OfficeID = O.OfficeID
             LEFT OUTER JOIN tbl_CompanyContact AS CC ON D.DealCurrentTargetID = CC.CompanyContactID
             LEFT OUTER JOIN tbl_BusinessArea AS BA ON CC.CompanyBusinessAreaID = BA.BusinessAreaID
             LEFT OUTER JOIN tbl_Country AS C ON CC.CompanyCountryID = C.CountryID
             LEFT OUTER JOIN tbl_DealStatusDetails dsd ON dsd.DealStatusID = d.DealStatusID
                                                          AND dsd.DealID = d.dealid
        WHERE 1 = CASE
                      WHEN D.DealTypeID IS NULL
                      THEN 1
                      WHEN D.DealTypeID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@DealTypeID, ',')
        )
                      THEN 1
                  END
             AND d.DealStatusID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@DealStageID, ',')
        )
        ORDER BY D.DealName ASC;
    END;
