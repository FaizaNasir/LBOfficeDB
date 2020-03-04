
-- exec [dbo].[GetContactTeamAutosuggest] @companyName='bnp',@individualID=8118

CREATE PROC [dbo].[GetContactTeamAutosuggest]
(@companyName  VARCHAR(1000), 
 @individualID INT
)
AS
    BEGIN
        SELECT CompanyName, 
               ci.CompanyIndividualID, 
               c.CompanyContactID, 
               ContactIndividualID, 
               TeamTypeName, 
               isMainCompany, 
               isMainIndividual, 
               ContactPositionInCompany, 
               ContactDepartmentInCompany, 
               ContactDateOfJoiningInCompany, 
               ContactDateOfLeavingFromCompany, 
               ContactDirectLineInCompany, 
               ContactDirectFaxInCompany, 
               ContactFaxNumberInCompany, 
               ContactMobileNumberInCompany, 
               ContactEmailAddressInCompany, 
               ContactPrivateAssitantID, 
               ContactRole, 
               co.OfficeID, 
               OfficeCity City, 
               co.CountryID
        FROM tbl_companycontact c
             LEFT JOIN tbl_companyindividuals ci ON c.companycontactid = ci.CompanyContactID
                                                    AND ci.ContactIndividualID = @individualID
             LEFT JOIN tbl_companyoffice co ON co.CompanyContactID = c.CompanyContactID
                                               AND ismain = 1
        WHERE c.companyName LIKE '%' + @companyName + '%';
    END;
