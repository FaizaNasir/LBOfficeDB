CREATE PROCEDURE [dbo].[proc_ContactIndividualRM_SET] --0,487,365,false  

(@Id                            INT, 
 @IndividualId                  INT, 
 @ManagementCompanyIndividualID INT, 
 @IsMain                        BIT
)
AS
    BEGIN

/*  
 Create Date : 24/12/2012 Reason : Insert Or Update Company Log Called    
 */

        IF(@Id = -1
           AND
        (
            SELECT COUNT(1)
            FROM tbl_ContactIndividualRM
            WHERE IndividualId = @IndividualId
                  AND ManagementCompanyIndividualID = @ManagementCompanyIndividualID
        ) < 1)
            BEGIN
                INSERT INTO [dbo].[tbl_ContactIndividualRM]
                ([IndividualId], 
                 [ManagementCompanyIndividualID], 
                 [IsMain]
                )
                VALUES
                (@IndividualId, 
                 @ManagementCompanyIndividualID, 
                 @IsMain
                );
                IF(
                (
                    SELECT COUNT(1)
                    FROM tbl_ContactIndividualRM
                    WHERE IndividualId = @IndividualId
                ) = 1)
                    BEGIN
                        UPDATE tbl_ContactIndividualRM
                          SET 
                              IsMain = 1
                        WHERE IndividualId = @IndividualId;
                END;
                SELECT 0 AS Success;
        END;
            ELSE
            BEGIN
                UPDATE tbl_ContactIndividualRM
                  SET 
                      IsMain = 0
                WHERE IndividualId = @IndividualId;
                UPDATE [dbo].[tbl_ContactIndividualRM]
                  SET 
                      [IndividualId] = @IndividualId, 
                      [ManagementCompanyIndividualID] = @ManagementCompanyIndividualID, 
                      [IsMain] = 1
                WHERE ManagementCompanyIndividualID = @ManagementCompanyIndividualID
                      AND IndividualId = @IndividualId;
                SELECT 0 AS Success;
        END;
    END;
