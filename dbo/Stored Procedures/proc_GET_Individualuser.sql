CREATE PROCEDURE [dbo].[proc_GET_Individualuser] --'khan zohair'  
@UserName NVARCHAR(256) = NULL
AS
    BEGIN
        SELECT tbl_ContactIndividual.IndividualFullName, 
               tbl_ContactIndividual.IndividualID
        FROM [tbl_Individualuser]
             INNER JOIN tbl_ContactIndividual ON tbl_Individualuser.individualID = tbl_ContactIndividual.individualID
        WHERE UserName = ISNULL(@UserName, UserName);
    END;
