
--  select dbo.[F_Diluted](1,3,'31 Dec, 2011')      

CREATE FUNCTION [dbo].[F_Innovativecriteria]
(@id INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @ConcatString VARCHAR(MAX);
         SELECT @ConcatString = COALESCE(@ConcatString + ', ', '') + InnovativeCriteriaName
         FROM [tbl_EligibilityInnovativeCriteria] c
              INNER JOIN tbl_InnovativeCriteria ON InnovateCriteriaID = InnovativeCriteriaID
         WHERE EligibilityID = @id;
         RETURN
         (
             SELECT @ConcatString
         );
     END;
