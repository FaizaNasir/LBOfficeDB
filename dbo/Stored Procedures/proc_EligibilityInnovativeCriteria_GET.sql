CREATE PROCEDURE [dbo].[proc_EligibilityInnovativeCriteria_GET] @EligibilityID INT = NULL
AS
    BEGIN
        SELECT EligibilityInnovativeCriteriaID, 
               EligibilityID, 
               InnovateCriteriaID, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_EligibilityInnovativeCriteria
        WHERE EligibilityID = @EligibilityID;
    END;
