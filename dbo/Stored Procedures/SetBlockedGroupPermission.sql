CREATE PROC [dbo].[SetBlockedGroupPermission]
(@ModuleID  INT, 
 @TypeID    INT, 
 @UserRole  VARCHAR(100), 
 @CreatedBy VARCHAR(100)
)
AS
    BEGIN
        INSERT INTO tbl_BlockedGroupPermission
        (ModuleID, 
         TypeID, 
         UserRole, 
         Active, 
         CreateDateTime, 
         CreatedBy
        )
               SELECT @ModuleID, 
                      @TypeID, 
                      @UserRole, 
                      1, 
                      GETDATE(), 
                      @CreatedBy;
        SELECT 1 Result;
    END;
