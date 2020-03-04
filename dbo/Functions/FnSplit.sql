﻿CREATE FUNCTION [dbo].[FnSplit]
(@List    NVARCHAR(2000), 
 @SplitOn NVARCHAR(5)
)
RETURNS @RtnValue TABLE
(Id    INT IDENTITY(1, 1), 
 Value NVARCHAR(100)
)
AS
     BEGIN
         WHILE(CHARINDEX(@SplitOn, @List) > 0)
             BEGIN
                 INSERT INTO @RtnValue(value)
                        SELECT Value = LTRIM(RTRIM(SUBSTRING(@List, 1, CHARINDEX(@SplitOn, @List) - 1)));
                 SET @List = SUBSTRING(@List, CHARINDEX(@SplitOn, @List) + LEN(@SplitOn), LEN(@List));
             END;
         INSERT INTO @RtnValue(Value)
                SELECT Value = LTRIM(RTRIM(@List));
         RETURN;
     END;
