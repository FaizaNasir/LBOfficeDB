CREATE PROC [dbo].[GetPortalUser]
(@email    VARCHAR(1000), 
 @password VARCHAR(1000)
)
AS
    BEGIN
        SELECT PortalUserID, 
               Email, 
               Password, 
               ObjectID, 
               Name, 
               ModuleID, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy, 
        (
            SELECT TOP 1 replace(LanguageID, ',', '')
            FROM tbl_ContactIndividual c
                 JOIN tbl_companyindividuals cc ON cc.contactindividualid = c.individualid
            WHERE cc.ContactEmailAddressInCompany = p.email
        ) Language, 
               ISNULL(IsAllowed, 0) IsAllowed
        FROM tbl_portaluser p
        WHERE email LIKE @email
              AND password LIKE @password;
    END;
