CREATE FUNCTION [dbo].[F_GetDealCompany]
(@dealid INT
)
RETURNS VARCHAR(4000)
AS
     BEGIN
         DECLARE @result VARCHAR(1000);
         SELECT @result = COALESCE(@result + ',', '') + CONVERT(VARCHAR(1000), ci.CompanyName)
         FROM tbl_dealcompany dt
              JOIN tbl_companycontact ci ON ci.companycontactid = dt.companyID
                                            AND dt.DealID = @dealid
         ORDER BY CompanyName;
         RETURN @result;
     END;
