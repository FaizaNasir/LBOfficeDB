CREATE PROCEDURE [dbo].[proc_Chart_Total _Number_Deal] @DateFrom   DATE, 
                                                       @Till       DATE, 
                                                       @DealStage  VARCHAR(1000), 
                                                       @DealOffice VARCHAR(1000), 
                                                       @DealRM     VARCHAR(1000)
AS
    BEGIN
        SELECT DT.ProjectTypeTitle, 
               D.dealid
        FROM tbl_deals AS D
             INNER JOIN tbl_DealType AS DT ON D.DealTypeID = DT.ProjectTypeID
             INNER JOIN tbl_DealTypeActivity AS DTA ON DTA.DealTypeID = DT.ProjectTypeID
                                                       AND DTA.ActivityID = 2

             --join b/c filter of deal office
             LEFT OUTER JOIN tbl_Office AS O ON D.OfficeID = O.OfficeID

             --join b/c filter of deal rm
             LEFT OUTER JOIN tbl_DealTeam AS DP ON D.DealID = DP.DealID
                                                   AND ISTeamLead = 1

             --join b/c filter of deal stage
             LEFT OUTER JOIN tbl_DealStages AS DLS ON D.DealStageID = DLS.DealStageID
        WHERE d.receiveddate BETWEEN @DateFrom AND @Till
              AND O.OfficeID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@DealOffice, ',')
        )
             AND DP.IndividualID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@DealRM, ',')
        )
        AND DLS.DealStageID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@DealStage, ',')
        )
        ORDER BY DT.ProjectTypeID;
    END;
