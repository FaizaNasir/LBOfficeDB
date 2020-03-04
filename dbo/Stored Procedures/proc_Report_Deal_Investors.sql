CREATE PROCEDURE [dbo].[proc_Report_Deal_Investors] @DealTypeID  VARCHAR(100), 
                                                    @DealStageID VARCHAR(100), 
                                                    @DealOffice  VARCHAR(100), 
                                                    @DealRM      VARCHAR(100)
AS
    BEGIN
        SELECT DISTINCT 
               D.DealID, 
               D.DealName AS 'Deal name', 
               D.DealSize, 
               O.OfficeName AS 'Office Name', 
               CC.CompanyName AS 'Investor name', 
               CI.IndividualFullName AS 'Deal contact', 
               DFI.ForecastedAmount, 
               DFI.ClosedAmount, 
               DFI.DealFundInvestorNotes AS 'Investor Notes', 
               DFIS.DealFundInvestorStatusName AS 'Investor Status', 
               DT.ProjectTypeTitle AS 'Deal type', 
               D.receiveddate AS 'Issue date'
        FROM tbl_deals AS D

             --join b/c filter of deal type  
             LEFT OUTER JOIN tbl_DealType AS DT ON D.DealTypeID = DT.ProjectTypeID

             --join b/c filter of deal office  
             LEFT OUTER JOIN tbl_Office AS O ON D.OfficeID = O.OfficeID

             --join b/c filter of deal rm  
             LEFT OUTER JOIN tbl_DealTeam AS DP ON D.DealID = DP.DealID
                                                   AND DP.IsTeamLead = 1

             --join b/c filter of deal stage  
             LEFT OUTER JOIN tbl_DealStages AS DLS ON D.DealStageID = DLS.DealStageID
             LEFT OUTER JOIN tbl_DealFundInvestors AS DFI ON D.DealID = DFI.DealID
             LEFT OUTER JOIN tbl_CompanyContact AS CC ON DFI.CompanyContactID = CC.CompanyContactID
             LEFT OUTER JOIN tbl_ContactIndividual AS CI ON DFI.DealCompanyMainContactID = CI.IndividualID
             LEFT OUTER JOIN tbl_DealFundInvestorStatus AS DFIS ON DFI.DealFundInvestorStatusID = DFIS.DealFundInvestorStatusID
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
