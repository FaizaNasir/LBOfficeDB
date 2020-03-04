
--Select ismaincompany from tbl_CompanyIndividuals where TeamTypeName = 'Executive Team' and ContactIndividualID = 588  

CREATE PROCEDURE [dbo].[proc_ContactCompanyMainComapny_SET] --'LBOfficeAdmin',220,588,1,'Executive Team'    

@RoleID       VARCHAR(50), 
@CompanyID    INT, 
@ContactID    INT, 
@isRemove     BIT          = 0, 
@TeamTypeName VARCHAR(100)
AS
    BEGIN
        UPDATE tbl_CompanyIndividuals
          SET 
              ismaincompany = 0
        WHERE --CompanyContactID=@CompanyID AND   

        TeamTypeName = @TeamTypeName
        AND ContactIndividualID = @ContactID;
        UPDATE tbl_CompanyIndividuals
          SET 
              isMainIndividual = 0
        WHERE CompanyContactID = @CompanyID
              AND TeamTypeName = @TeamTypeName;
        IF(@isRemove = 1)
            BEGIN
                UPDATE tbl_CompanyIndividuals
                  SET 
                      ismaincompany = 1
                WHERE CompanyContactID = @CompanyID
                      AND ContactIndividualID = @ContactID
                      AND TeamTypeName = @TeamTypeName;
                UPDATE tbl_CompanyIndividuals
                  SET 
                      isMainIndividual = 1
                WHERE CompanyContactID = @CompanyID
                      AND ContactIndividualID = @ContactID
                      AND TeamTypeName = @TeamTypeName;
        END;
        SELECT 0;
    END;
