CREATE PROCEDURE [dbo].[proc_Tasks_GET] @TaskID       INT          = NULL, 
                                        @TaskName     VARCHAR(MAX) = NULL, 
                                        @ParentTaskID INT          = NULL
AS
    BEGIN
        SELECT *
        FROM tbl_Tasks T           
        --left JOIN tbl_TaskLinked L ON L.TaskID=T.TaskID   
        WHERE t.TaskID = ISNULL(@TaskID, t.TaskID)
              AND TaskName = ISNULL(@TaskName, TaskName)
              AND ISNULL(ParentTaskID, 0) = ISNULL(@ParentTaskID, ISNULL(ParentTaskID, 0));
    END;
