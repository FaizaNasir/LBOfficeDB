CREATE PROC [dbo].[proc_companyoptional_get](@CompanyID INT)
AS
    BEGIN
        SELECT CompanyOptionalID, 
               CompanyID, 
               AMLFinalized, 
               ClientType, 
               AMLCategory, 
               ClientPoliticallyExposed, 
               ResidenceCountry, 
               ClientMet, 
               LastReviewDate, 
               Active, 
               CreatedDate, 
               ModifiedDate, 
               CreatedBy, 
               ModifiedBy, 
        (
            SELECT CountryName
            FROM tbl_Country c
            WHERE c.countryID = ResidenceCountry
        ) CountryName
        FROM tbl_companyoptional
        WHERE CompanyID = @CompanyID;
    END;
