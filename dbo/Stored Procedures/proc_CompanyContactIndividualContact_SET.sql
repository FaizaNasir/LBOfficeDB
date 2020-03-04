CREATE PROCEDURE [dbo].[proc_CompanyContactIndividualContact_SET] @CompanyContactID                INT          = NULL, 
                                                                  @ContactIndividualID             INT          = NULL, 
                                                                  @ContactPositionInCompany        VARCHAR(100) = NULL, 
                                                                  @ContactDepartmentInCompany      VARCHAR(100) = NULL, 
                                                                  @ContactDateOfJoiningInCompany   DATETIME     = NULL, 
                                                                  @ContactDateOfLeavingFromCompany DATETIME     = NULL, 
                                                                  @ContactDirectLineInCompany      VARCHAR(100) = NULL, 
                                                                  @ContactDirectFaxInCompany       VARCHAR(100) = NULL, 
                                                                  @ContactFaxNumberInCompany       VARCHAR(100) = NULL, 
                                                                  @ContactMobileNumberInCompany    VARCHAR(100) = NULL, 
                                                                  @ContactEmailAddressInCompany    VARCHAR(100) = NULL, 
                                                                  @ContactPrivateAssitantID        INT          = NULL, 
                                                                  @ContactRole                     VARCHAR(100) = NULL, 
                                                                  @TeamTypeName                    VARCHAR(100) = NULL, 
                                                                  @officeID                        INT          = NULL
AS
    BEGIN
        IF EXISTS
        (
            SELECT 1
            FROM tbl_CompanyIndividuals
            WHERE [CompanyContactID] = @CompanyContactID
                  AND @ContactIndividualID = [ContactIndividualID]
                  AND TeamTypeName = @TeamTypeName
        )
            BEGIN
                UPDATE [tbl_CompanyIndividuals]
                  SET 
                      [ContactPositionInCompany] = @ContactPositionInCompany, 
                      OfficeID = @officeID, 
                      [ContactDepartmentInCompany] = @ContactDepartmentInCompany, 
                      [ContactDateOfJoiningInCompany] = @ContactDateOfJoiningInCompany, 
                      [ContactDateOfLeavingFromCompany] = @ContactDateOfLeavingFromCompany, 
                      [ContactDirectLineInCompany] = @ContactDirectLineInCompany, 
                      [ContactDirectFaxInCompany] = @ContactDirectFaxInCompany, 
                      [ContactFaxNumberInCompany] = @ContactFaxNumberInCompany, 
                      [ContactMobileNumberInCompany] = @ContactMobileNumberInCompany, 
                      [ContactEmailAddressInCompany] = @ContactEmailAddressInCompany, 
                      [ContactPrivateAssitantID] = ISNULL(@ContactPrivateAssitantID, [ContactPrivateAssitantID]), 
                      [ContactRole] = @ContactRole, 
                      [TeamTypeName] = @TeamTypeName
                WHERE [CompanyContactID] = @CompanyContactID
                      AND @ContactIndividualID = [ContactIndividualID]
                      AND TeamTypeName = @TeamTypeName;
                SELECT 0 AS Success;
        END;
            ELSE
            BEGIN
                INSERT INTO [tbl_CompanyIndividuals]
                ([CompanyContactID], 
                 [ContactIndividualID], 
                 [ContactPositionInCompany], 
                 [ContactDepartmentInCompany], 
                 [ContactDateOfJoiningInCompany], 
                 [ContactDateOfLeavingFromCompany], 
                 [ContactDirectLineInCompany], 
                 [ContactDirectFaxInCompany], 
                 [ContactFaxNumberInCompany], 
                 [ContactMobileNumberInCompany], 
                 [ContactEmailAddressInCompany], 
                 [ContactPrivateAssitantID], 
                 [ContactRole], 
                 [TeamTypeName], 
                 officeID
                )
                VALUES
                (@CompanyContactID, 
                 @ContactIndividualID, 
                 @ContactPositionInCompany, 
                 @ContactDepartmentInCompany, 
                 @ContactDateOfJoiningInCompany, 
                 @ContactDateOfLeavingFromCompany, 
                 @ContactDirectLineInCompany, 
                 @ContactDirectFaxInCompany, 
                 @ContactFaxNumberInCompany, 
                 @ContactMobileNumberInCompany, 
                 @ContactEmailAddressInCompany, 
                 @ContactPrivateAssitantID, 
                 @ContactRole, 
                 @TeamTypeName, 
                 @officeID
                );
                SELECT 0 AS Success;
        END;
        IF
        (
            SELECT COUNT(1)
            FROM tbl_companyindividuals
            WHERE CompanyContactID = @CompanyContactID
        ) = 1
            BEGIN
                UPDATE tbl_companyindividuals
                  SET 
                      isMainIndividual = 1
                WHERE CompanyContactID = @CompanyContactID;
        END;
        IF
        (
            SELECT COUNT(1)
            FROM tbl_companyindividuals
            WHERE ContactIndividualID = @ContactIndividualID
        ) = 1
            BEGIN
                UPDATE tbl_companyindividuals
                  SET 
                      isMainCompany = 1
                WHERE ContactIndividualID = @ContactIndividualID;
        END;
    END;
