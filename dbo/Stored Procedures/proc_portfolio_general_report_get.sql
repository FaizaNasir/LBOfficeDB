CREATE PROCEDURE [dbo].[proc_portfolio_general_report_get](@VehicleID AS VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        CREATE TABLE #tmpportfoliocompany
        (portfolioid      INT, 
         companycontactid INT, 
         companyname      VARCHAR(MAX) NULL
        );
        INSERT INTO #tmpportfoliocompany
        EXEC proc_portfolio_list_report_get 
             @VehicleID;
        SELECT DISTINCT 
               pv.portfolioid, 
               pv.companyname AS [Portfolio company name], 
               currencycode AS [Portfolio company currency], 
               capital AS [Portfolio company legal], 
               companylogo AS [Portfolio company logo], 
               businessareatitle AS [Portfolio company sector], 
               companyindustrytitle AS [Portfolio company industry], 
               companybusinessdesc AS [Portfolio company business profile], 
               companyaddress AS [Portfolio company address], 
               cityname AS [Portfolio company city], 
               companyzip AS [Portfolio company zip code], 
               countryname AS [Portfolio company country], 
               companyphone AS [Portfolio company phone number], 
               companyfax AS [Portfolio company fax number], 
               companywebsite AS [Portfolio company website], 
               companycomments AS [Portfolio company notes]
        FROM #tmpportfoliocompany PV
             JOIN [tbl_companycontact] CC ON cc.companycontactid = pv.companycontactid
             LEFT JOIN tbl_businessarea BA ON ba.businessareaid = cc.companybusinessareaid
             LEFT JOIN tbl_companyindustries CInd ON cind.companyindustryid = cc.companyindustryid
             LEFT JOIN tbl_country Coun ON coun.countryid = cc.companycountryid
             LEFT JOIN tbl_city City ON city.countryid = cc.companycountryid
                                        AND city.cityid = cc.companycityid
             LEFT JOIN tbl_portfoliolegal pl ON pl.portfolioid = pv.portfolioid
             LEFT JOIN tbl_currency Curr ON curr.currencyid = pl.currencyid;
        SET NOCOUNT OFF;
    END;
