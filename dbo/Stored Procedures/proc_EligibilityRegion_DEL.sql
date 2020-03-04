CREATE PROCEDURE [dbo].[proc_EligibilityRegion_DEL] @EligibilityID INT
AS
     DELETE FROM [tbl_EligibilityRegion]
     WHERE EligibilityID = @EligibilityID;
     SELECT 1 AS 'Result';
