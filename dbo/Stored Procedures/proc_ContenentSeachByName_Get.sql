CREATE PROCEDURE [dbo].[proc_ContenentSeachByName_Get] --'as'

@ContenentName NVARCHAR(100)
AS
    BEGIN
        DECLARE @SQL VARCHAR(MAX)= NULL;
        SET @SQL = 'Select [ContenentID]

      ,[ContenentName]

      ,[Active] FROM [tbl_Contenents] where ContenentName like''%' + @ContenentName + '%''';
        EXEC SP_EXECUTESQL 
             @SQL;
        PRINT(@SQL);
    END;
