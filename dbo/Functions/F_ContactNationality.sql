CREATE FUNCTION [dbo].[F_ContactNationality]
(@id INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @return_value VARCHAR(MAX);
         SET @return_value =
         (
             SELECT SUBSTRING(
             (
                 SELECT ',' + CountryName
                 FROM
                 (
                     SELECT ci.CountryName
                     FROM tbl_nationality n
                          JOIN tbl_ContactIndividual i ON i.individualID = n.Individualid
                          JOIN tbl_country ci ON ci.countryid = n.countryid
                     WHERE i.IndividualID = @id
                 ) t FOR XML PATH('')
             ), 2, 200000)
         );
         RETURN @return_value;
     END;
