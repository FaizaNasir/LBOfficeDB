CREATE FUNCTION [dbo].[DelimitedSplit8K]

--===== Define I/O parameters  

(@Str       VARCHAR(8000), 
 @Delimiter CHAR(1)
)

--WARNING!!! DO NOT USE MAX DATA-TYPES HERE!  IT WILL KILL PERFORMANCE!  
RETURNS TABLE
WITH SCHEMABINDING
AS
     RETURN

     -- Append delimiter at the beginning and end
     -- SET @Str = @Delimiter + @Str + @Delimiter

     SELECT SUBSTRING(@Str, ID + 1, CHARINDEX(@Delimiter, @Str, ID + 1) - ID - 1) SplitedString
     FROM dbo.Tally
     WHERE ID < LEN(@Str)
           AND SUBSTRING(@Str, ID, 1) = @Delimiter;
