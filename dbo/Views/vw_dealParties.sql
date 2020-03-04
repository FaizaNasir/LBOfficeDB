CREATE VIEW [dbo].[vw_dealParties]
AS
     SELECT DISTINCT 
            D.DealID, 
            D.DealName AS [Deal name], 
            CC.CompanyName AS Client, 
            D.DealSize, 
            BA.BusinessAreaTitle AS Sector, 
            CI.IndividualFullName AS [Received by], 
            CIRM.IndividualFullName AS RM, 
            REPLACE(dbo.F_GetDealWorkingTeam(D.DealID), ',', ',') AS [MC team members], 
            REPLACE(dbo.F_GetDealStageApproval(D.DealID), ',', ',') AS [Approved by], 
            REPLACE(dbo.F_GetDealNegativeList(D.DealID), ',', ',') AS [Negative list], 
            REPLACE(dbo.F_GetDealTaskExternalAdvisor(D.DealID), ',', ',') AS [External advisor], 
            D.ReceivedDate AS [Issue date], 
            CI.IndividualID, 
            CC.CompanyContactID
     FROM dbo.tbl_Deals AS D
          LEFT OUTER JOIN dbo.tbl_DealType AS DT ON D.DealTypeID = DT.ProjectTypeID
          LEFT OUTER JOIN dbo.tbl_Office AS O ON D.OfficeID = O.OfficeID
          LEFT OUTER JOIN dbo.tbl_CompanyContact AS CC ON D.DealCurrentTargetID = CC.CompanyContactID
          LEFT OUTER JOIN dbo.tbl_DealTeam AS DP ON D.DealID = DP.DealID
                                                    AND DP.IsTeamLead = 1
          LEFT OUTER JOIN dbo.tbl_BusinessArea AS BA ON CC.CompanyBusinessAreaID = BA.BusinessAreaID
          LEFT OUTER JOIN dbo.tbl_ContactIndividual AS CI ON D.ReceiverId = CI.IndividualID
          LEFT OUTER JOIN dbo.tbl_DealTeam AS DTRM ON D.DealID = DTRM.DealID
                                                      AND DTRM.IsTeamLead = 1
          LEFT OUTER JOIN dbo.tbl_ContactIndividual AS CIRM ON DTRM.IndividualID = CIRM.IndividualID
          LEFT OUTER JOIN dbo.tbl_DealStages AS DLS ON D.DealStageID = DLS.DealStageID;
