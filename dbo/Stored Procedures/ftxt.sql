CREATE PROC [dbo].[ftxt](@txt VARCHAR(MAX))
AS
     SELECT *
     FROM sys.procedures
     WHERE object_id IN
     (
         SELECT id
         FROM syscomments
         WHERE text LIKE '%' + @txt + '%'
     );
