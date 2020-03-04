
--select * from dbo.[SplitCSV]('sdasd,',',')

CREATE FUNCTION [dbo].[SplitCSV]
(@Str       VARCHAR(8000), 
 @Delimiter CHAR(1)
)
RETURNS @temptable TABLE(items VARCHAR(8000))
AS
     BEGIN
         SET @Str = @Delimiter + @Str + @Delimiter;
         INSERT INTO @temptable
                SELECT SUBSTRING(@Str, ID + 1, CHARINDEX(@Delimiter, @Str, ID + 1) - ID - 1) SplitedString
                FROM dbo.Tally
                WHERE ID < LEN(@Str)
                      AND SUBSTRING(@Str, ID, 1) = @Delimiter
                      AND SUBSTRING(@Str, ID + 1, CHARINDEX(@Delimiter, @Str, ID + 1) - ID - 1) <> '';
         RETURN;
     END;
