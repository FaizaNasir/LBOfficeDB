CREATE PROCEDURE [dbo].[proc_Report_Deal_Stage] --'','','',''

@DealTypeID  VARCHAR(100), 
@DealStageID VARCHAR(100), 
@DealOffice  VARCHAR(100), 
@DealRM      VARCHAR(100)
AS
    BEGIN
        SELECT DISTINCT 
               D.DealName AS 'Deal name', 
               CC.CompanyName AS Client, 
               ELT.DealStatusDateTime AS 'Engagement letter date', 
               AD.DealStatusDateTime AS 'Acceptance date', 
               DS.ProjectStatusTitle AS 'Last status', 
               DSD.DealStatusDateTime AS 'Last status date', 
               DSD.DealStatusComments AS 'Last status comments', 
               D.receiveddate AS 'Issue date'
        FROM tbl_deals AS D

             --join b/c filter of deal type
             LEFT OUTER JOIN tbl_DealType AS DT ON D.DealTypeID = DT.ProjectTypeID
             LEFT OUTER JOIN tbl_DealStatus AS DS ON D.DealStatusID = DS.ProjectStatusID

             --join b/c filter of deal office
             LEFT OUTER JOIN tbl_Office AS O ON D.OfficeID = O.OfficeID
             LEFT OUTER JOIN tbl_CompanyContact AS CC ON D.DealCurrentTargetID = CC.CompanyContactID

             --join b/c filter of deal rm
             LEFT OUTER JOIN tbl_DealTeam AS DP ON D.DealID = DP.DealID
                                                   AND DP.IsTeamLead = 1
             LEFT OUTER JOIN tbl_DealStatusDetails AS ELT ON D.DealID = ELT.DealID
                                                             AND ELT.DealStatusID = 3
             LEFT OUTER JOIN tbl_DealStatusDetails AS AD ON D.DealID = AD.DealID
                                                            AND AD.DealStatusID = 4
             LEFT OUTER JOIN tbl_DealStatusDetails DSD ON D.DealID = DSD.DealID
                                                          AND D.DealStatusID = DSD.DealStatusID

             --join b/c filter of deal stage
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
