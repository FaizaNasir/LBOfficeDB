CREATE PROC [dbo].[GetCompanies_ExcelPlugin]
AS
    BEGIN
        SELECT DISTINCT 
               cc.CompanyContactID, 
               cc.CompanyName, 
               dbo.F_GetCompanyTypeNames(cc.CompanyContactID) CompanyType, 
               co.OfficeAddress, 
               co.OfficeCity, 
               co.OfficeZip, 
               c.CountryName, 
               co.OfficePhone, 
               co.OfficeFax, 
               cc.CompanyWebSite, 
               cc.CompanyComments, 
               ci.CompanyIndustryTitle, 
               ba.BusinessAreaTitle, 
               cc.CompanyBusinessDesc, 
               cc.CompanyCreationDate, 
               cc.CompanyStartCollaborationDate, 
               s.StateTitle State
        FROM tbl_companycontact cc
             LEFT JOIN tbl_BusinessArea ba ON ba.BusinessAreaID = cc.CompanyBusinessAreaID
             LEFT JOIN tbl_CompanyIndustries ci ON ci.CompanyIndustryID = cc.CompanyIndustryID
             LEFT JOIN tbl_companyoffice co ON co.companycontactid = cc.companycontactid
                                               AND co.ismain = 1
                                               AND co.CountryID IS NOT NULL
             LEFT JOIN tbl_country c ON c.countryid = co.countryID
             LEFT JOIN tbl_state s ON s.StateID = co.StateID
        ORDER BY cc.CompanyName;
    END;
