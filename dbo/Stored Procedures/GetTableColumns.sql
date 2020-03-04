
CREATE PROC [dbo].[GetTableColumns](@tableName VARCHAR(100))
AS
    BEGIN
        DECLARE @result VARCHAR(MAX);
        SET @result = '';
        SELECT @result = @result + COLUMN_NAME + ','
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @tableName;
        SELECT REVERSE(STUFF(REVERSE(@result), 1, 1, ''));
    END;


