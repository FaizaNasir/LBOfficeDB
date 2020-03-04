CREATE PROCEDURE [dbo].[proc_ContactIndividual_MainCompany_GET] --1,'d'
@RoleID   INT, 
@Critaria VARCHAR(100) = NULL
AS
    BEGIN
        SELECT C.CompanyContactID, 
               ISNULL(C.CompanyName, '') + '-' + CASE
                                                     WHEN C.CompanyAddress IS NOT NULL
                                                     THEN C.CompanyAddress
                                                     ELSE ' '
                                                 END AS CompanyFullName
        FROM tbl_CompanyContact C
        WHERE C.CompanyName LIKE '' + @Critaria + '%';
    END;
