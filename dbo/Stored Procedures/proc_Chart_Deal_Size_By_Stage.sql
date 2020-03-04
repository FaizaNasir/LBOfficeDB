CREATE PROCEDURE [dbo].[proc_Chart_Deal_Size_By_Stage] @DateFrom   DATE, 
                                                       @Till       DATE, 
                                                       @Sector     VARCHAR(100), 
                                                       @Country    VARCHAR(1000), 
                                                       @DealOffice VARCHAR(100), 
                                                       @DealRM     VARCHAR(100)
AS
    BEGIN
        SELECT ds.DealStageTitle, 
               d.dealid, 
               d.DealSize, 
               d.DealCurrencyCode
        FROM tbl_deals AS d
             INNER JOIN tbl_DealStages AS ds ON d.dealstageid = ds.DealStageID

             --join b/c filter of deal office
             LEFT OUTER JOIN tbl_Office AS O ON D.OfficeID = O.OfficeID

             --join b/c filter of deal rm
             LEFT OUTER JOIN tbl_DealTeam AS DP ON D.DealID = DP.DealID
                                                   AND ISTeamLead = 1

             --join b/c filter of client country
             LEFT OUTER JOIN tbl_CompanyContact AS CC ON D.DealCurrentTargetID = CC.CompanyContactID
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
        AND CC.CompanyCountryID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@Country, ',')
        )
        AND CC.CompanyBusinessAreaID IN
        (
            SELECT *
            FROM dbo.[SplitCSV](@Sector, ',')
        )
        ORDER BY ds.DealStageTitle;
    END;
