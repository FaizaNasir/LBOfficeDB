CREATE PROC [dbo].[proc_contact_ExcelImport]
(@title                 VARCHAR(100), 
 @Lastname              VARCHAR(100), 
 @Firstname             VARCHAR(100), 
 @Maincompany           INT, 
 @Position              VARCHAR(100), 
 @Businessemail         VARCHAR(100), 
 @Telephonprofessionnel VARCHAR(100), 
 @Telephonemobile       VARCHAR(100), 
 @description           VARCHAR(100)
)
AS
    BEGIN
        INSERT INTO tbl_ContactIndividual
        (IndividualTitle, 
         IndividualFirstName, 
         IndividualLastName, 
         IndividualFullName,
         --IndividualPhone,
         --IndividualMobile,
         --IndividualEmail,
         IndividualComments
        )
               SELECT @title, 
                      @Firstname, 
                      @Lastname, 
                      @Lastname + ' ' + @Firstname,
                      --@Telephonprofessionnel,
                      --@Telephonemobile,
                      --@Businessemail,
                      @description;
        DECLARE @id INT;
        SET @id = SCOPE_IDENTITY();
        IF @Maincompany IS NOT NULL
            BEGIN
                INSERT INTO tbl_CompanyIndividuals
                (CompanyContactID, 
                 ContactIndividualID, 
                 TeamTypeName, 
                 isMainCompany, 
                 isMainIndividual, 
                 ContactPositionInCompany, 
                 ContactEmailAddressInCompany, 
                 ContactDirectLineInCompany, 
                 ContactMobileNumberInCompany
                )
                       SELECT @Maincompany, 
                              @id, 
                              'Executive Team', 
                              1, 
                              1, 
                              @Position, 
                              @Businessemail, 
                              @Telephonprofessionnel, 
                              @Telephonemobile;
        END;
        SELECT 1 result;
    END;
