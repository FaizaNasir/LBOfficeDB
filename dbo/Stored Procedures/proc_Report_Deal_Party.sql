CREATE PROCEDURE [dbo].[proc_Report_Deal_Party] --'','','',''

@DealTypeID  VARCHAR(100) = NULL, 
@DealStageID VARCHAR(100) = NULL, 
@DealOffice  VARCHAR(100) = NULL, 
@DealRM      VARCHAR(100) = NULL
AS
    BEGIN
        SELECT DISTINCT 
               D.DealID, 
               D.DealName AS 'Deal name', 
               CC.CompanyName AS Client, 
               D.DealSize, 
               BA.BusinessAreaTitle AS Sector, 
               CI.IndividualFullName AS 'Received by', 
               CIRM.IndividualFullName AS RM, 
               REPLACE(dbo.F_GetDealWorkingTeam(D.DealID), ',', ',') AS 'MC team members', 
               REPLACE(dbo.F_GetDealStageApproval(D.DealID), ',', ',') AS 'Approved by', 
               REPLACE(dbo.F_GetDealNegativeList(D.DealID), ',', ',') AS 'Negative list', 
               REPLACE(dbo.F_GetDealTaskExternalAdvisor(D.DealID), ',', ',') AS 'External advisor', 
               D.receiveddate AS 'Issue date'
        FROM tbl_deals AS D

             --join b/c filter of deal type
             LEFT OUTER JOIN tbl_DealType AS DT ON D.DealTypeID = DT.ProjectTypeID

             --join b/c filter of deal status
             --left outer join tbl_DealStatus as DS ON
             --D.DealStatusID = DS.ProjectStatusID
             --join b/c filter of deal office
             LEFT OUTER JOIN tbl_Office AS O ON D.OfficeID = O.OfficeID

             --Deal Target Company Name
             LEFT OUTER JOIN tbl_CompanyContact AS CC ON D.DealCurrentTargetID = CC.CompanyContactID

             --join b/c filter of deal rm
             LEFT OUTER JOIN tbl_DealTeam AS DP ON D.DealID = DP.DealID
                                                   AND DP.IsTeamLead = 1

             --Target Company Business Area Name
             LEFT OUTER JOIN tbl_BusinessArea AS BA ON CC.CompanyBusinessAreaID = BA.BusinessAreaID

             --Received By of deal
             LEFT OUTER JOIN tbl_ContactIndividual AS CI ON D.ReceiverID = CI.IndividualID

             --Deal Main RM
             LEFT OUTER JOIN tbl_DealTeam AS DTRM ON D.DealID = DTRM.DealID
                                                     AND DTRM.IsTeamLead = 1

             --Name of Deal Main RM
             LEFT OUTER JOIN tbl_ContactIndividual AS CIRM ON DTRM.IndividualID = CIRM.IndividualID
             LEFT OUTER JOIN tbl_DealStages AS DLS ON D.DealStageID = DLS.DealStageID
        WHERE 
        --DT.ProjectTypeID = ISNULL(@DealTypeID,DT.ProjectTypeID) AND
        DT.ProjectTypeID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@DealTypeID, ',')
        )
             AND --DS.ProjectStatusID = ISNULL(@DealStageID,DS.ProjectStatusID) AND
             DLS.DealStageID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@DealStageID, ',')
        )
AND --O.OfficeID = ISNULL(@DealOffice,O.OfficeID)  AND
O.OfficeID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@DealOffice, ',')
        )
AND DP.IndividualID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@DealRM, ',')
        )
        --DP.IndividualID = ISNull(@DealRM,DP.IndividualID) 

        ORDER BY D.DealName ASC;
    END;
