CREATE PROC [dbo].[ValidateLPDistributionTeamContacts](@contacts VARCHAR(MAX))
AS
    BEGIN
        SELECT DISTINCT 
               c.IndividualFullName
        FROM tbl_contactIndividual c
             LEFT JOIN tbl_CompanyIndividuals ci ON c.IndividualID = ci.ContactIndividualID
                                                    AND ci.isMainCompany = 1
        WHERE ISNULL(c.IndividualEmail, '') = ''
              AND ISNULL(ci.ContactEmailAddressInCompany, '') = ''
              AND '4|' + CAST(c.IndividualID AS VARCHAR(10)) IN
        (
            SELECT *
            FROM dbo.SplitCSV(@contacts, ',')
        );
    END;
