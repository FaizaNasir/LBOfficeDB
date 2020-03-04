CREATE VIEW [dbo].[vw_DealFlow_List]
AS
     SELECT DISTINCT 
            D.DealName AS 'Deal name', 
            DT.ProjectTypeTitle AS 'Deal type', 
            DS.ProjectStatusTitle AS 'Deal stage', 
            D.DealSize, 
            O.OfficeName AS 'Office Name', 
            D.Notes, 
            CC.CompanyName AS Client, 
            BA.BusinessAreaTitle AS Sector, 
            C.CountryName AS Country, 
            D.ReceivedDate AS 'Issue date'
     FROM dbo.tbl_Deals AS D
          LEFT OUTER JOIN dbo.tbl_DealType AS DT ON D.DealTypeID = DT.ProjectTypeID
          LEFT OUTER JOIN dbo.tbl_DealStatus AS DS ON D.DealStatusID = DS.ProjectStatusID
          LEFT OUTER JOIN dbo.tbl_Office AS O ON D.OfficeID = O.OfficeID
          LEFT OUTER JOIN dbo.tbl_CompanyContact AS CC ON D.DealCurrentTargetID = CC.CompanyContactID
          LEFT OUTER JOIN dbo.tbl_BusinessArea AS BA ON CC.CompanyBusinessAreaID = BA.BusinessAreaID
          LEFT OUTER JOIN dbo.tbl_Country AS C ON CC.CompanyCountryID = C.CountryID
          LEFT OUTER JOIN dbo.tbl_DealTeam AS DP ON D.DealID = DP.DealID
                                                    AND DP.IsTeamLead = 1
          LEFT OUTER JOIN dbo.tbl_DealStages AS DLS ON D.DealStageID = DLS.DealStageID;
