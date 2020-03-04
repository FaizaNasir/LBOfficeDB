CREATE PROCEDURE [dbo].[proc_IndividualSearchByFirstNameLastNameCompanyName_Get] --'LBOfficeAdmin','faisal'            

@RoleID              VARCHAR(100), 
@IndividualFirstName VARCHAR(100)  = NULL, 
@IndividualLastName  VARCHAR(100)  = NULL, 
@CompanyContactIDs   VARCHAR(1000) = NULL, 
@AndOR               VARCHAR(100)  = 'AND'
AS
    BEGIN
        DECLARE @SQL VARCHAR(MAX)= NULL;
        SET @SQL = 'select distinct c.*,CI.CompanyName as MainCompanyName,ci.CompanyContactID,CI.ContactDirectLineInCompany,CI.ContactDirectFaxInCompany,CI.ContactMobileNumberInCompany,CI.ContactEmailAddressInCompany  FROM tbl_ContactIndividual C        


     







LEFT JOIN tbl_CompanyIndividuals cic







on cic.ContactIndividualID = c.IndividualID







left join tbl_companycontact cc on cc.CompanyContactID = cic.CompanyContactID















 LEFT JOIN vw_ContactIndividualsWithCompanyContacts CI ON CI.ContactIndividualID=C.IndividualID AND CI.isMainCompany=1             















 left join  tbl_ModuleObjectPermissions AS P ON C.IndividualID = P.ModuleObjectID             















     AND P.ModuleName = ''ContactIndividual'' AND P.RoleID = '' + convert(varchar(100),@RoleID) + ''--AND P.CanView=1            















 WHERE 1=1  And ISNULL(P.CanView,1) = 1 ' + CASE
                                                WHEN @IndividualFirstName IS NULL
                                                THEN ' '
                                                ELSE @AndOR + '(C.individualFullname like ''%' + @IndividualFirstName + '%'' OR c.IndividualComments like ''%' + @IndividualFirstName + '%'' OR cc.CompanyName like ''%' + @IndividualFirstName + '%'')'
                                            END + CASE
                                                      WHEN @CompanyContactIDs IS NULL
                                                      THEN ' '
                                                      ELSE @AndOR + ' C.IndividualID in (select ContactIndividualID from tbl_CompanyIndividuals            















  Where CompanyContactID in (' + @CompanyContactIDs + '))'
                                                  END + CASE
                                                            WHEN @IndividualLastName IS NULL
                                                            THEN ' '
                                                            ELSE @AndOR + ' (C.IndividualFullName like ''%' + @IndividualLastName + '%''  OR c.IndividualComments like ''%' + @IndividualLastName + '%''  OR cc.CompanyName like ''%' + @IndividualLastName + '%'')'
                                                        END;
        SET @SQL = @SQL + '  order by C.IndividualFullName  ';
        EXEC (@SQL);
        PRINT(@SQL);
    END;
