CREATE FUNCTION [dbo].[F_GetCompanyAddress]
(@id INT
)
RETURNS VARCHAR(1000)
AS
     BEGIN
         DECLARE @result VARCHAR(1000);
         SET @result =
         (
             SELECT ISNULL(OfficeAddress, '') + ' - ' + ISNULL(OfficeZip, '') + ' ' + ISNULL(OfficeCity, '')
             --+ ' ' +
             --ISNULL((select StateTitle from tbl_state s where s.stateid = co.stateid),'') + ' ' +
             --ISNULL((select countryname from tbl_country c where c.countryid = co.countryid),'')

             FROM tbl_companyoffice co
             WHERE co.CompanyContactID = @id
                   AND co.ismain = 1
         );
         RETURN ISNULL(@result, NULL);
     END;
