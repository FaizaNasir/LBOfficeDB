CREATE PROCEDURE [dbo].[proc_EligibilityInnovativeCriteria_SET] @EligibilityID      INT          = NULL, 
                                                                @InnovateCriteriaID INT          = NULL, 
                                                                @Active             BIT          = NULL, 
                                                                @CreatedDateTime    DATETIME     = NULL, 
                                                                @ModifiedDateTime   DATETIME     = NULL, 
                                                                @CreatedBy          VARCHAR(100) = NULL, 
                                                                @ModifiedBy         VARCHAR(100) = NULL
AS
     DECLARE @EligibilityInnovativeCriteriaID INT= NULL;
    BEGIN
        INSERT INTO [tbl_EligibilityInnovativeCriteria]
        (EligibilityID, 
         InnovateCriteriaID, 
         Active, 
         CreatedDateTime, 
         ModifiedDateTime, 
         CreatedBy, 
         ModifiedBy
        )
        VALUES
        (@EligibilityID, 
         @InnovateCriteriaID, 
         @Active, 
         @CreatedDateTime, 
         @ModifiedDateTime, 
         @CreatedBy, 
         @ModifiedBy
        );
        SET @EligibilityInnovativeCriteriaID = @@IDENTITY;
        SELECT 'SUCESS' AS RESULT, 
               @EligibilityInnovativeCriteriaID 'EligibilityInnovativeCriteriaID';
    END;
