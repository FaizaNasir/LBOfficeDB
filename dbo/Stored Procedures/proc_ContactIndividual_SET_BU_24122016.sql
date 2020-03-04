CREATE PROCEDURE [dbo].[proc_ContactIndividual_SET_BU_24122016] @ContactIndividualID    INT           = NULL, 
                                                                @CountryID              INT           = NULL, 
                                                                @CityID                 INT           = NULL, 
                                                                @ContactTypeID          VARCHAR(1000) = NULL, 
                                                                @IndividualTitle        VARCHAR(100)  = NULL, 
                                                                @IndividualFirstName    VARCHAR(100)  = NULL, 
                                                                @IndividualMiddleName   VARCHAR(100)  = NULL, 
                                                                @IndividualLastName     VARCHAR(100)  = NULL, 
                                                                @IndividualDOB          DATETIME      = NULL, 
                                                                @IndividualPhone        VARCHAR(100)  = NULL, 
                                                                @IndividualMobile       VARCHAR(100)  = NULL, 
                                                                @IndividualEmail        VARCHAR(100)  = NULL, 
                                                                @IndividualAddress      VARCHAR(100)  = NULL, 
                                                                @IndividualZipCode      VARCHAR(100)  = NULL, 
                                                                @IndividualPOBox        VARCHAR(100)  = NULL, 
                                                                @IndividualImage        VARCHAR(MAX)  = NULL, 
                                                                @IndividualBackground   VARCHAR(100)  = NULL, 
                                                                @IndividualComments     VARCHAR(5000) = NULL, 
                                                                @IndividualKnowledgeID  INT           = NULL, 
                                                                @IndividualFacebookID   VARCHAR(100)  = NULL, 
                                                                @IndividualLinkedInID   VARCHAR(100)  = NULL, 
                                                                @IndividualSkypeID      VARCHAR(100)  = NULL, 
                                                                @IndividualTwitterID    VARCHAR(100)  = NULL, 
                                                                @IndividualOtherSNIDs   VARCHAR(100)  = NULL, 
                                                                @IndividualFax          VARCHAR(100)  = NULL, 
                                                                @ExternalAdvisorTypesID VARCHAR(1000) = NULL, 
                                                                @IndividualExpertIn     VARCHAR(100)  = NULL, 
                                                                @languageID             VARCHAR(200), 
                                                                @office                 VARCHAR(5000) = NULL
AS
    BEGIN

        --INSERT INTO tbl_temp
        --       SELECT 'cc',
        --              @ContactTypeID;  

        DECLARE @NewContactID INT= NULL;

        -------- Individual --------        

        IF(@ContactIndividualID IS NULL)
            BEGIN
                IF(@IndividualLastName IS NULL)
                    BEGIN
                        SELECT 'Individual last name must be defined' AS Success, 
                               NULL AS ContactIndividualID;
                        RETURN;
                END;
                CREATE TABLE #Validate
                (Result            VARCHAR(100), 
                 ResultDescription VARCHAR(1000)
                );
                INSERT INTO #Validate
                EXEC [proc_Validate_IndividualName] 
                     @IndividualFirstName, 
                     @IndividualMiddleName, 
                     @IndividualLastName, 
                     @IndividualEmail;
                IF EXISTS
                (
                    SELECT 1
                    FROM #Validate
                    WHERE Result = 'Fail'
                )
                    BEGIN
                        SELECT ResultDescription AS Success, 
                               NULL AS ContactIndividualID
                        FROM #Validate;
                        RETURN;
                END;
                INSERT INTO [tbl_ContactIndividual]
                ([IndividualCountryID], 
                 [IndividualCityID], 
                 [IndividualTitle], 
                 [IndividualFirstName], 
                 [IndividualMiddleName], 
                 [IndividualLastName], 
                 [IndividualFullName], 
                 [IndividualDOB], 
                 [IndividualPhone], 
                 [IndividualMobile], 
                 [IndividualEmail], 
                 [IndividualAddress], 
                 [IndividualZipCode], 
                 [IndividualPOBox], 
                 [IndividualPhoto], 
                 [IndividualBackground], 
                 [IndividualComments], 
                 [IndividualKnowledgeID], 
                 [IndividualFacebookID], 
                 [IndividualLinkedInID], 
                 [IndividualSkypeID], 
                 [IndividualTwitterID], 
                 [IndividualOtherSNIDs], 
                 [IndividualFax], 
                 [IndividualExpertIn], 
                 LanguageID, 
                 Office
                )
                VALUES
                (@CountryID, 
                 @CityID, 
                 @IndividualTitle, 
                 @IndividualFirstName, 
                 @IndividualMiddleName, 
                 @IndividualLastName, 
                 ISNULL(@IndividualLastName, '') + CASE
                                                       WHEN @IndividualMiddleName IS NOT NULL
                                                       THEN ' ' + ISNULL(@IndividualMiddleName, '')
                                                       ELSE ''
                                                   END + ' ' + ISNULL(@IndividualFirstName, ''), 
                 @IndividualDOB, 
                 @IndividualPhone, 
                 @IndividualMobile, 
                 @IndividualEmail, 
                 @IndividualAddress, 
                 @IndividualZipCode, 
                 @IndividualPOBox, 
                 @IndividualImage, 
                 @IndividualBackground, 
                 @IndividualComments, 
                 @IndividualKnowledgeID, 
                 @IndividualFacebookID, 
                 @IndividualLinkedInID, 
                 @IndividualSkypeID, 
                 @IndividualTwitterID, 
                 @IndividualOtherSNIDs, 
                 @IndividualFax, 
                 @IndividualExpertIn, 
                 @languageID, 
                 @office
                );
                SELECT @ContactIndividualID = @@IDENTITY;
                SELECT 'Success' AS Success, 
                       @ContactIndividualID AS ContactIndividualID;
                SELECT @NewContactID = @ContactIndividualID;
                IF(@ContactTypeID IS NOT NULL)
                    BEGIN
                        EXEC proc_IndividualContactTypes_SET 
                             @NewContactID, 
                             @ContactTypeID;
                END;
        END;
            ELSE
            BEGIN
                IF(@IndividualFirstName IS NULL)
                    BEGIN
                        SELECT 'Individual first name must be defined' AS Success, 
                               NULL AS ContactIndividualID;
                        RETURN;
                END;
                UPDATE [tbl_ContactIndividual]
                  SET 
                      [IndividualCountryID] = @CountryID, 
                      [IndividualCityID] = @CityID, 
                      [IndividualTitle] = @IndividualTitle, 
                      [IndividualFirstName] = @IndividualFirstName, 
                      [IndividualMiddleName] = @IndividualMiddleName, 
                      [IndividualFullName] = ISNULL(@IndividualLastName, '') + CASE
                                                                                   WHEN @IndividualMiddleName IS NOT NULL
                                                                                   THEN ' ' + ISNULL(@IndividualMiddleName, '')
                                                                                   ELSE ''
                                                                               END + ' ' + ISNULL(@IndividualFirstName, ''), 
                      [IndividualLastName] = @IndividualLastName, 
                      [IndividualDOB] = @IndividualDOB, 
                      [IndividualPhone] = @IndividualPhone, 
                      [IndividualMobile] = @IndividualMobile, 
                      [IndividualEmail] = @IndividualEmail, 
                      [IndividualAddress] = @IndividualAddress, 
                      [IndividualZipCode] = @IndividualZipCode, 
                      [IndividualPOBox] = @IndividualPOBox, 
                      [IndividualPhoto] = @IndividualImage, 
                      [IndividualBackground] = @IndividualBackground, 
                      [IndividualComments] = @IndividualComments, 
                      [IndividualKnowledgeID] = @IndividualKnowledgeID, 
                      [IndividualFacebookID] = @IndividualFacebookID, 
                      [IndividualLinkedInID] = @IndividualLinkedInID, 
                      [IndividualSkypeID] = @IndividualSkypeID, 
                      [IndividualTwitterID] = @IndividualTwitterID, 
                      [IndividualOtherSNIDs] = @IndividualOtherSNIDs, 
                      [IndividualFax] = @IndividualFax, 
                      [IndividualExpertIn] = @IndividualExpertIn, 
                      [LanguageID] = @languageID, 
                      [Office] = @office
                WHERE IndividualID = @ContactIndividualID;
                IF(@ContactTypeID IS NOT NULL)
                    BEGIN
                        EXEC proc_IndividualContactTypes_SET 
                             @ContactIndividualID, 
                             @ContactTypeID;
                END;
                SELECT 'Success' AS Success, 
                       @ContactIndividualID AS ContactIndividualID;
        END;
    END;
