-- proc_dealStagePermission_set 'LbofficeAdmin',2

CREATE PROC [dbo].[proc_dealStagePermission_set]
(@roleName VARCHAR(100), 
 @stageID  INT
)
AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_DealStagePermission
            WHERE rolename = @roleName
                  AND DealStageID = @stageID
        )
            INSERT INTO tbl_DealStagePermission
            (DealStageID, 
             RoleName
            )
                   SELECT @stageID, 
                          @roleName;
        SELECT 1 Result;
    END;
