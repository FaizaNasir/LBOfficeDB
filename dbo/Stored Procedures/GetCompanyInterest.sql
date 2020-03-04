CREATE PROC [dbo].[GetCompanyInterest]
(@companyid INT, 
 @type      VARCHAR(100)
)
AS
    BEGIN
        SELECT CompanyInterestID, 
               CompanyID, 
               Year, 
               Notes, 
               Rate, 
               Type, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_companyinterest ci
        WHERE ci.companyID = @companyid
              AND type = @type
        ORDER BY year DESC;
    END;
