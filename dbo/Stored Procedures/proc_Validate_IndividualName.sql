--select * from tbl_ContactIndividual    
-- [dbo].[proc_Validate_IndividualName] 'z_123',null,'z_321',''    

CREATE PROCEDURE [dbo].[proc_Validate_IndividualName]-- 'z_123','','z_321',''    
@FirstName  VARCHAR(100), 
@MiddleName VARCHAR(100), 
@LastName   VARCHAR(100), 
@Email      VARCHAR(100) = NULL
AS
    BEGIN
        IF @Email = ''
            SET @Email = NULL;
        DECLARE @FullName VARCHAR(100);
        SET @FullName = ISNULL(@FirstName, '#') + ',' + ISNULL(@MiddleName, '#') + ',' + ISNULL(@LastName, '#');
        IF EXISTS
        (
            SELECT 1
            FROM tbl_ContactIndividual
            WHERE ISNULL(IndividualFirstName, '#') + ',' + ISNULL(IndividualMiddleName, '#') + ',' + ISNULL(IndividualLastName, '#') = @FullName
        )
            BEGIN
                DECLARE @IndividualID INT= NULL, @IndividualEmail VARCHAR(100)= NULL;
                SELECT @IndividualID = IndividualID, 
                       @IndividualEmail = IndividualEmail
                FROM tbl_ContactIndividual
                WHERE ISNULL(IndividualFirstName, '#') + ',' + ISNULL(IndividualMiddleName, '#') + ',' + ISNULL(IndividualLastName, '#') = @FullName;
                IF @IndividualEmail = ''
                    SET @IndividualEmail = NULL;
                IF(@IndividualEmail IS NULL
                   AND @Email IS NULL)
                    BEGIN
                        SELECT 'Fail' AS Result, 
                               'Please provide email as user with out email already exists' AS ResultDescription;
                        RETURN;
                END;
                IF(@IndividualEmail IS NOT NULL
                   AND @Email IS NOT NULL)
                    BEGIN
                        IF EXISTS
                        (
                            SELECT 1
                            FROM tbl_ContactIndividual
                            WHERE IndividualID = @IndividualID
                                  AND IndividualEmail = @Email
                        )
                            BEGIN
                                SELECT 'Fail' AS Result, 
                                       'username with same email address already exists' AS ResultDescription;
                                RETURN;
                        END;
                END;

                --SELECT 'user with same name already exists' as Result,'NA' as ResultDescription     
                SELECT 'Success' AS Result, 
                       'NA' AS ResultDescription;
        END;
            ELSE
            IF(@Email IS NOT NULL)
                BEGIN
                    IF EXISTS
                    (
                        SELECT 1
                        FROM tbl_ContactIndividual
                        WHERE IndividualEmail = @Email
                    )
                        BEGIN
                            SELECT 'Fail' AS Result, 
                                   'username with same email address already exists' AS ResultDescription;
                            RETURN;
                    END;
            END;
                ELSE
                SELECT 'Success' AS Result, 
                       'NA' AS ResultDescription;
    END; 
