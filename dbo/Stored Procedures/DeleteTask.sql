CREATE PROC [dbo].[DeleteTask](@TaskID INT)
AS
    BEGIN
        DELETE FROM tbl_TaskLinked
        WHERE TaskID = @TaskID;
        DELETE FROM tbl_Tasks
        WHERE TaskID = @TaskID;
        SELECT 1 Result, 
               '' Msg;
    END;
