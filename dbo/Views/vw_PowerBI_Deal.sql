CREATE VIEW [dbo].[vw_PowerBI_Deal]
AS
     SELECT DISTINCT 
            d.dealid, 
            d.Dealname 'Deal name', 
            cc.companyname 'Target name', 
            dtt.ProjectTypeTitle 'Deal type', 
            d.dealsize 'Deal size', 
            d.Receiveddate 'Received date', 
            d.valuation 'Target valuation', 
            c.Countryname 'Country', 
            ba.BusinessAreaDesc 'Sector', 
            ci.IndividualFullName 'Team lead', 
     (
         SELECT TOP 1 ds.ProjectStatusTitle
         FROM tbl_DealStatusDetails dsd
              INNER JOIN tbl_DealStatus ds ON ds.ProjectStatusID = dsd.DealStatusID
         WHERE dsd.DealID = d.dealid
         ORDER BY dsd.DealStatusDetailsID DESC
     ) 'Last stage'
     FROM tbl_deals d
          INNER JOIN tbl_DealTarget dt ON d.dealid = dt.dealid
          LEFT OUTER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = dt.ModuleObjectID
          LEFT OUTER JOIN tbl_DealType dtt ON dtt.ProjectTypeID = d.dealtypeid
          LEFT OUTER JOIN tbl_country c ON c.countryid = cc.CompanyCountryID
          LEFT OUTER JOIN tbl_BusinessArea ba ON cc.CompanyBusinessAreaID = ba.BusinessAreaID
          LEFT OUTER JOIN tbl_DealTeam dte ON dte.DealID = d.dealid
                                              AND dte.IsTeamLead = 1
          LEFT OUTER JOIN tbl_ContactIndividual ci ON ci.IndividualID = dte.IndividualID;
