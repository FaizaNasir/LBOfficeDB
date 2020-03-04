CREATE PROCEDURE [dbo].[proc_InnovativeCriteria_GET]
AS
    BEGIN
        SELECT [InnovativeCriteriaID], 
               [InnovativeCriteriaName], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM tbl_InnovativeCriteria
        WHERE Active = 1;
    END;
