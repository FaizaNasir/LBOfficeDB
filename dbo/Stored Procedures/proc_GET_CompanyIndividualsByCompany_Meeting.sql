
--proc_GET_CompanyIndividualsByCompany_Meeting '148'
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_GET_CompanyIndividualsByCompany_Meeting] @CompanyContactID    INT = NULL, 
                                                                      @ContactIndividualID INT = NULL
AS --select * from tbl_CompanyIndividuals
    BEGIN
        SELECT *
        FROM [tbl_ContactIndividual] C
             INNER JOIN tbl_CompanyIndividuals I ON C.IndividualID = I.ContactIndividualID
        WHERE I.CompanyContactID = ISNULL(@CompanyContactID, CompanyContactID); 
        --AND CompanyIndividualID = ISNULL(@ContactIndividualID,ContactIndividualID)

    END;
