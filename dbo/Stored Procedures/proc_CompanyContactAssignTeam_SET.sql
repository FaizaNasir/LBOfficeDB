CREATE PROCEDURE [dbo].[proc_CompanyContactAssignTeam_SET] @CompanyContactID    INT, 
                                                           @ContactIndividualID INT, 
                                                           @TeamTypeName        VARCHAR(100), 
                                                           @ContactRole         VARCHAR(100)
AS
    BEGIN
        IF EXISTS
        (
            SELECT 1
            FROM tbl_CompanyIndividuals
            WHERE CompanyContactID = @CompanyContactID
                  AND 1 = 0
                  AND ContactIndividualID = @ContactIndividualID
        )
            BEGIN
                UPDATE tbl_CompanyIndividuals
                  SET 
                      TeamTypeName = @TeamTypeName
                WHERE CompanyContactID = @CompanyContactID
                      AND CompanyIndividualID = @ContactIndividualID;
                SELECT 'Success' AS Success, 
                       @@IDENTITY AS newcontactCompanyID;
        END;
            ELSE
            BEGIN
                INSERT INTO tbl_CompanyIndividuals
                (CompanyContactID, 
                 ContactIndividualID, 
                 TeamTypeName, 
                 ContactRole
                )
                       SELECT @CompanyContactID, 
                              @ContactIndividualID, 
                              @TeamTypeName, 
                              @ContactRole;
                IF(
                (
                    SELECT COUNT(1)
                    FROM tbl_CompanyIndividuals
                    WHERE CompanyContactID = @CompanyContactID
                          AND TeamTypeName = @TeamTypeName
                ) = 1)
                    BEGIN
                        UPDATE tbl_CompanyIndividuals
                          SET 
                              isMainIndividual = 1
                        WHERE CompanyContactID = @CompanyContactID
                              AND TeamTypeName = @TeamTypeName;
                END;
                SELECT 'Success' AS Success, 
                       @@IDENTITY AS newcontactCompanyID;
        END;

                --SELECT 'Success' as Success,@@IDENTITY as newcontactCompanyID   

    END;
