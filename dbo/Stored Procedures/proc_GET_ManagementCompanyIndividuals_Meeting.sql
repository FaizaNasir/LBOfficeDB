-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_GET_ManagementCompanyIndividuals_Meeting] @CompanyContactID    INT = NULL, 
                                                                       @ContactIndividualID INT = NULL
AS
    BEGIN
        SELECT *
        FROM [tbl_ContactIndividual];
        --WHERE CompanyContactID = ISNULL(@CompanyContactID,CompanyContactID) 
        --AND CompanyIndividualID = ISNULL(@ContactIndividualID,ContactIndividualID)
        -- SELECT * FROM [tbl_CompanyContact]

    END;
