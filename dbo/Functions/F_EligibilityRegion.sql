
--  select dbo.[F_Diluted](1,3,'31 Dec, 2011')      

CREATE FUNCTION [dbo].[F_EligibilityRegion]
(@id INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @ConcatString VARCHAR(MAX);
         SELECT @ConcatString = COALESCE(@ConcatString + ', ', '') + RegionName
         FROM tbl_EligibilityRegion er
              INNER JOIN tbl_Region r ON er.RegionID = r.RegionID
         WHERE er.EligibilityID = @id;
         RETURN
         (
             SELECT @ConcatString
         );
     END;
