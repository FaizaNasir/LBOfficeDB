CREATE PROCEDURE [dbo].[proc_EligibilityInnovativeCriteria_DEL] @EligibilityID INT
AS
     DELETE FROM [tbl_EligibilityInnovativeCriteria]
     WHERE EligibilityID = @EligibilityID;
     SELECT 1 AS 'Result';
