CREATE PROCEDURE [dbo].[proc_Company_Teams_GET]
(@CompanyContactID AS INT          = NULL, 
 @TeamName AS         VARCHAR(500) = NULL
)
AS
    BEGIN
        SELECT ConIn.IndividualFullName AS [Contact name], 
               ContactPositionInCompany AS [Position], 
               ContactDepartmentInCompany AS [Department], 
               ContactDateOfJoiningInCompany AS [Joined On], 
               ContactDateOfLeavingFromCompany AS [Left On]
        FROM tbl_CompanyIndividuals CI
             JOIN tbl_ContactIndividual ConIn ON CI.ContactIndividualID = ConIn.IndividualID
        WHERE companycontactid = ISNULL(@CompanyContactID, companycontactid)
              AND TeamTypeName = ISNULL(@TeamName, TeamTypeName);
    END;
