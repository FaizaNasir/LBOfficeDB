CREATE PROCEDURE [dbo].[ILPAPortfolioReport_Geography] @companyID INT
AS
    BEGIN
        --DECLARE @companyID INT;
        --SET @companyID = 4372;
        SELECT [Percentage], 
               tbl_Country.[CountryName]
        FROM tbl_InterestAppetiteGeographyCountry
             LEFT OUTER JOIN tbl_InterestGeoghraphyCountryDetail ON tbl_InterestGeoghraphyCountryDetail.InterestAppetiteGeoghraphyCountryID = tbl_InterestAppetiteGeographyCountry.InterestAppetiteGeoghraphyCountryID
             INNER JOIN tbl_Country ON tbl_Country.CountryID = tbl_InterestGeoghraphyCountryDetail.CountryID
        WHERE ObjectID = @companyID
              AND IsCompany = 1
        ORDER BY [Percentage] DESC;
    END;
