CREATE PROC [dbo].[finduser](@name VARCHAR(2000))
AS
     SELECT *
     FROM tbl_ContactIndividual(NOLOCK)
     WHERE IndividualFullName LIKE '%' + @name + '%';
